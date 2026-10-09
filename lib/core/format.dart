// author: juraj.suchan@gmail.com

String formatDateTime(DateTime t) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${t.day}.${t.month}.${t.year} ${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}
