import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:remote_rift_utils/remote_rift_utils.dart';

import '../../../data/models.dart';
import '../../../i18n/strings.g.dart';
import '../game_cubit.dart';

class GameQueueSelectionButton extends StatelessWidget {
  const GameQueueSelectionButton({super.key, required this.availableQueues});

  final List<GameQueue> availableQueues;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Transform.translate(
      offset: Offset(-12, 0),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size(0, 32),
          tapTargetSize: .shrinkWrap,
          maximumSize: Size(.infinity, 32),
          padding: .symmetric(horizontal: 12, vertical: 4),
          backgroundColor: Colors.grey[200],
          foregroundColor: textTheme.bodyMedium?.color,
        ),
        onPressed: () =>
            GameQueueSelectionModal.selectAndUpdateQueue(context, availableQueues: availableQueues),
        child: Text(t.gameQueue.selectButton),
      ),
    );
  }
}

class GameQueueSelectionModal extends StatelessWidget {
  const GameQueueSelectionModal({super.key, required this.availableQueues});

  final List<GameQueue> availableQueues;

  static Future<void> selectAndUpdateQueue(
    BuildContext context, {
    required List<GameQueue> availableQueues,
  }) async {
    final cubit = context.read<GameCubit>();
    final queue = await show(context, availableQueues: availableQueues);
    if (queue != null && context.mounted) {
      cubit.createLobby(queueId: queue.id);
    }
  }

  static Future<GameQueue?> show(BuildContext context, {required List<GameQueue> availableQueues}) {
    final cubit = context.read<GameCubit>();

    final heightRatio = switch (MediaQuery.orientationOf(context)) {
      .portrait => 0.7,
      .landscape => 0.85,
    };
    final maxHeight = MediaQuery.sizeOf(context).height * heightRatio;

    return showModalBottomSheet<GameQueue>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: maxHeight),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: GameQueueSelectionModal(availableQueues: availableQueues),
      ),
    );
  }

  void _selectAndPop(BuildContext context, GameQueue queue) {
    context.read<GameCubit>().createLobby(queueId: queue.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: ListView(
        padding: .symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const .symmetric(horizontal: 16),
            child: Text(
              t.gameQueue.selectionTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 8),

          for (var (index, (:title, :queues)) in _resolveData().indexed) ...[
            if (index > 0) Divider(indent: 12, endIndent: 12, thickness: 0.5),
            _QueuesSection(
              title: title,
              queues: queues,
              onSelect: (queue) => _selectAndPop(context, queue),
            ),
          ],

          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  List<({String title, Iterable<GameQueue> queues})> _resolveData() {
    final aiQueues = availableQueues.where((queue) => queue.category == .ai);
    final pvpQueues = availableQueues
        .where((queue) => queue.category == .pvp)
        .groupedBy((queue) => queue.group)
        .mapValues((queues) => queues.orderedBy((queue) => queue.enabled ? 0 : 1))
        .records
        .orderedBy((item) => item.$1.orderRank);

    return [
      for (var (group, queues) in pvpQueues) (title: group.displayName, queues: queues),
      if (aiQueues.isNotEmpty) (title: t.gameQueue.selectionAiTitle, queues: aiQueues),
    ];
  }
}

class _QueuesSection extends StatelessWidget {
  const _QueuesSection({required this.title, required this.queues, required this.onSelect});

  final String title;
  final Iterable<GameQueue> queues;
  final void Function(GameQueue queueId) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: .bold),
          ),
        ),

        for (var queue in queues)
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: .circular(12)),
            enabled: queue.enabled,
            visualDensity: .compact,
            onTap: () => onSelect(queue),
            title: Text(queue.name),
            trailing: queue.enabled ? Icon(Icons.chevron_right) : null,
          ),
      ],
    );
  }
}
