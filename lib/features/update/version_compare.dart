// author: juraj.suchan@gmail.com

List<int>? parseVersion(String value) {
  final m = RegExp(r'^v?(\d+)\.(\d+)\.(\d+)').firstMatch(value.trim());
  if (m == null) return null;
  return [for (var i = 1; i <= 3; i++) int.parse(m.group(i)!)];
}

bool isNewerVersion(String candidate, String current) {
  final a = parseVersion(candidate);
  final b = parseVersion(current);
  if (a == null || b == null) return false;
  for (var i = 0; i < 3; i++) {
    if (a[i] != b[i]) return a[i] > b[i];
  }
  return false;
}
