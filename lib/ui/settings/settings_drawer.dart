import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/lifecycle.dart';
import '../widgets/text_field.dart';
import 'settings_cubit.dart';
import 'settings_state.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();

    return Lifecycle(
      onInit: cubit.initialize,
      child: Drawer(
        child: Padding(
          padding: .symmetric(horizontal: 24, vertical: 12),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
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

class ApiAddressField extends StatefulWidget {
  const ApiAddressField({super.key, required this.initialValue, required this.onChanged});

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<ApiAddressField> createState() => _ApiAddressFieldState();
}

class _ApiAddressFieldState extends State<ApiAddressField> {
  final _controller = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Api address',
        suffixIconConstraints: const BoxConstraints(minWidth: 22, minHeight: 22),
        suffixIcon: _modified ? _suffixButtons() : null,
      ),
      onSubmitted: (value) {
        widget.onChanged(_controller.text);
        FocusScope.of(context).unfocus();
      },
    );
  }

  Widget _suffixButtons() {
    return Row(
      mainAxisSize: .min,
      children: [
        TextFieldSuffixButton(
          icon: Icons.undo,
          onTap: () {
            _controller.text = widget.initialValue;
          },
        ),
        TextFieldSuffixButton(
          icon: Icons.check,
          onTap: () {
            widget.onChanged(_controller.text);
            FocusScope.of(context).unfocus();
          },
        ),
      ],
    );
  }
}
