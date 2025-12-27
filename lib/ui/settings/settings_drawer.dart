import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../app/app_theme.dart';
import '../widgets/lifecycle.dart';
import 'settings_cubit.dart';
import 'settings_state.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  static Widget builder() {
    return BlocProvider(create: Dependencies.settingsCubit, child: SettingsDrawer());
  }

  static void open(BuildContext context, {bool autofocus = false}) {
    final scope = SettingsDrawerScope.of(context);
    Scaffold.of(context).openEndDrawer();
    if (autofocus) {
      scope.apiAddressFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();

    const materialDrawerWidth = 304.0;
    final safeAreaRight = MediaQuery.of(context).viewPadding.right;

    return Lifecycle(
      onInit: cubit.initialize,
      child: Drawer(
        width: materialDrawerWidth + safeAreaRight,
        child: Padding(
          padding: .symmetric(horizontal: 24, vertical: 12),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(t.settings.title, style: Theme.of(context).appBarTheme.titleTextStyle),
                SizedBox(height: 12),
                switch (cubit.state) {
                  Initial() => Padding(
                    padding: const .all(12),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  Data(:var apiAddress) => ApiAddressField(
                    initialValue: apiAddress ?? '',
                    onChanged: cubit.changeApiAddress,
                  ),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsDrawerScope extends StatefulWidget {
  const SettingsDrawerScope({super.key, required this.child});

  final Widget child;

  static SettingsDrawerScopeState of(BuildContext context) {
    final scope = context.findAncestorStateOfType<SettingsDrawerScopeState>();
    if (scope == null) {
      throw FlutterError(
        'SettingsDrawerScope requested from a context that does not contain a SettingsDrawerScope widget.',
      );
    }
    return scope;
  }

  @override
  State<SettingsDrawerScope> createState() => SettingsDrawerScopeState();
}

class SettingsDrawerScopeState extends State<SettingsDrawerScope> {
  final apiAddressFocusNode = FocusNode();

  @override
  void dispose() {
    apiAddressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class ApiAddressField extends StatefulWidget {
  const ApiAddressField({super.key, required this.initialValue, required this.onChanged});

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<ApiAddressField> createState() => _ApiAddressFieldState();
}

class _ApiAddressFieldState extends State<ApiAddressField> {
  final _controller = TextEditingController();

  FocusNode get _focusNode => SettingsDrawerScope.of(context).apiAddressFocusNode;

  bool get _modified => widget.initialValue != _controller.text;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitText() {
    _controller.text = _controller.text.trim();
    widget.onChanged(_controller.text);
  }

  void _dropFocus() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        _header(),
        _inputField(),
        if (_modified) ...[SizedBox(height: 12), _actionButtons()],
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(t.settings.apiAddressTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(t.settings.apiAddressDescription),
      ],
    );
  }

  Widget _inputField() {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: t.settings.apiAddressHint,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      onTapOutside: (_) => _dropFocus(),
      onSubmitted: (value) {
        _submitText();
        _dropFocus();
      },
    );
  }

  Widget _actionButtons() {
    final buttonSize = AppThemeExtension.buttonSize(.medium);

    return Row(
      mainAxisSize: .min,
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.undo),
            label: Text(t.settings.undoButton),
            style: OutlinedButton.styleFrom(minimumSize: buttonSize),
            onPressed: () {
              _controller.text = widget.initialValue;
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.check),
            label: Text(t.settings.saveButton),
            style: ElevatedButton.styleFrom(minimumSize: buttonSize),
            onPressed: () {
              _submitText();
              _dropFocus();
            },
          ),
        ),
      ],
    );
  }
}
