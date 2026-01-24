import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';
import 'time_countdown.dart';

class GameFoundCountdown extends StatelessWidget {
  const GameFoundCountdown({super.key, required this.maxTime, required this.timeLeft});

  final double maxTime;
  final double timeLeft;

  @override
  Widget build(BuildContext context) {
    return TimeCountdown(
      start: maxTime,
      current: timeLeft,
      drift: 1,
      builder: (progress, seconds) => Column(
        children: [
          const SizedBox(height: 12),
          Text(t.gameState.foundPendingTimeLeft, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text('${seconds.ceil()}', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progress, minHeight: 8, borderRadius: .circular(4)),
        ],
      ),
    );
  }
}
