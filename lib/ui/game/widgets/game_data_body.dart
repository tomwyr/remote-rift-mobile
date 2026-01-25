import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/layout.dart';

class GameDataBody extends StatelessWidget {
  const GameDataBody({
    super.key,
    required this.queueName,
    required this.title,
    required this.description,
    this.child,
  });

  final String? queueName;
  final String title;
  final String description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 12,
      children: [
        if (queueName case var queueName?)
          BasicLayoutSection(label: t.home.gameModeLabel, title: queueName),
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
