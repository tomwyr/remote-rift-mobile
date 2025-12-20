import 'package:vibration/vibration.dart';

Future<void> vibrateMillis(int duration) async {
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate(duration: duration);
  }
}
