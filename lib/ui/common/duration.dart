extension DurationFrom on Duration {
  static Duration secondsDouble(double seconds) {
    final fullSeconds = seconds.floor();
    final millis = ((seconds - fullSeconds) * 1000).floor();
    return Duration(seconds: fullSeconds, milliseconds: millis);
  }
}
