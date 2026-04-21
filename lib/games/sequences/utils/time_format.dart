String formatDuration(int totalSeconds) {
  if (totalSeconds < 0) totalSeconds = 0;
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}

String formatMs(int ms) => formatDuration((ms / 1000).ceil());
