import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../settings/settings_drawer.dart';
import '../widgets/layout.dart';
import '../widgets/lifecycle.dart';
import 'connection_cubit.dart';
import 'connection_state.dart';

class ConnectionComponent extends StatelessWidget {
  const ConnectionComponent({super.key, required this.connectedBuilder});

  final WidgetBuilder connectedBuilder;

  static Widget builder({required WidgetBuilder connectedBuilder}) {
    return BlocProvider(
      create: Dependencies.connectionCubit,
      child: ConnectionComponent(connectedBuilder: connectedBuilder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ConnectionCubit>();

    return Lifecycle(
      onInit: cubit.initialize,
      child: switch (cubit.state) {
        Initial() => SizedBox.shrink(),

        ConfigurationRequired() => BasicLayout(
          title: t.connection.configurationRequiredTitle,
          description: t.connection.configurationRequiredDescription,
          action: .new(
            label: t.home.configureButton,
            onPressed: () => SettingsDrawer.open(context, autofocus: true),
          ),
        ),

        Connecting() => BasicLayout(title: t.connection.connecting, loading: true),

        ConnectionError(:var reconnectTriggered) => BasicLayout(
          title: t.connection.errorTitle,
          description: t.connection.errorDescription,
          loading: reconnectTriggered,
          action: .new(label: t.connection.errorRetry, onPressed: cubit.reconnect),
        ),

        ConnectedWithError(:var cause) => BasicLayout(
          title: cause.title,
          description: cause.description,
        ),

        Connected() => connectedBuilder(context),
      },
    );
  }
}
