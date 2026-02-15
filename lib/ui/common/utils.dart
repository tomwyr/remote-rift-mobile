import 'package:remote_rift_ui/remote_rift_ui.dart';
import 'package:vibration/vibration.dart';

Future<void> vibrateMillis(int duration) async {
  if (AppLifecycle.currentState != .resumed) {
    return;
  }
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate(duration: duration);
  }
}
