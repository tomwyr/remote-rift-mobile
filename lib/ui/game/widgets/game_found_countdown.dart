import 'dart:math';

import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';
import '../../widgets/time_countdown.dart';

class GameFoundCountdown extends StatelessWidget {
  const GameFoundCountdown({super.key, required this.maxTime, required this.timeLeft});

  final double maxTime;
  final double timeLeft;

  @override
  Widget build(BuildContext context) {
    // Reduce time left slightly to account for the async communication delay
    // to better align the countdown with the game UI.
    final effectiveTimeLeft = max(timeLeft - 0.1, 0.0);

    return TimeCountdown(
      start: maxTime,
      current: effectiveTimeLeft,
      drift: 1.5,
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
