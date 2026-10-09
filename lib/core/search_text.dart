// author: juraj.suchan@gmail.com

({String? user, String? text})? splitSearch(String text) {
  if (text.isEmpty) return null;

  if (text.startsWith('@')) {
    final end = text.indexOf(' ');
    final user = end > 0 ? text.substring(1, end) : text.substring(1);
    final rest = end > 0 ? text.substring(end + 1) : null;
    return (user: user, text: rest);
  }
  return (user: null, text: text);
}
