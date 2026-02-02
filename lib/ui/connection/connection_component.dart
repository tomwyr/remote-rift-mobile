import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_ui/remote_rift_ui.dart';

import '../../data/models.dart';
import '../../dependencies.dart';
import '../../i18n/strings.g.dart';
import '../common/utils.dart';
import '../widgets/bloc_listener.dart';
import '../widgets/delayed_display.dart';
import '../widgets/layout.dart';
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
      child: BlocTransitionListener(
        bloc: cubit,
        listener: _vibrateOnStateChange,
        child: switch (cubit.state) {
          Initial() => SizedBox.shrink(),

          // Delay showing content to avoid flicker when loading appears for a single frame
          Connecting() => DelayedDisplay(
            delay: Duration(milliseconds: 200),
            placeholder: BasicLayout(loading: true),
            child: BasicLayout(
              title: t.connection.connectingTitle,
              description: t.connection.connectingDescription,
              loading: true,
            ),
          ),

          ConnectionError(:var cause, :var reconnectTriggered) => BasicLayout(
            title: t.connection.errorTitle,
            description: cause.description,
            loading: reconnectTriggered,
            action: .new(label: t.connection.errorRetry, onPressed: cubit.reconnectAfterError),
          ),

          ConnectedWithError(:var cause) => BasicLayout(
            title: cause.title,
            description: cause.description,
          ),

          ConnectedIncompatible() => BasicLayout(
            title: t.connection.incompatibleTitle,
            description: t.connection.incompatibleDescription,
            action: .new(
              label: t.connection.incompatibleRetry,
              onPressed: cubit.reconnectAfterIncompatibility,
            ),
          ),

          Connected() => connectedBuilder(context),
        },
      ),
    );
  }

  void _vibrateOnStateChange(ConnectionState previous, ConnectionState current) {
    bool changedTo<T extends ConnectionState>() {
      return previous is! T && current is T;
    }

    if (changedTo<ConnectionError>() || changedTo<ConnectedWithError>()) {
      vibrateMillis(300);
    }
  }
}
