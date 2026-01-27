import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/layout.dart';

class GameDataBody extends StatelessWidget {
  const GameDataBody({
    super.key,
    this.queueName,
    this.queueNamePlaceholder,
    required this.title,
    required this.description,
    this.child,
  });

  final String? queueName;
  final Widget? queueNamePlaceholder;
  final String title;
  final String description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    var effectiveQueueName = queueName;
    // Use placeholder text only if no placeholder widget is provided.
    if (queueNamePlaceholder == null) {
      effectiveQueueName ??= t.gameQueue.unknownPlaceholder;
    }

    return Column(
      crossAxisAlignment: .start,
      spacing: 12,
      children: [
        BasicLayoutSection(
          label: t.home.gameModeLabel,
          title: effectiveQueueName,
          titlePlaceholder: queueNamePlaceholder,
        ),
        BasicLayoutSection(
          label: t.home.gameStateLabel,
          title: title,
          titleFontSize: .large,
          description: description,
        ),
        ?child,
      ],
    );
  }
}
