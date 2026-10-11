// author: juraj.suchan@gmail.com

class AppRelease {
  const AppRelease({
    required this.version,
    required this.notes,
    required this.pageUrl,
    this.apkUrl,
  });

  final String version;
  final String notes;
  final String pageUrl;
  final String? apkUrl;

  static final _apkName = RegExp(r'^nyxdroid-v?\d+\.\d+\.\d+\.apk$');

  String get downloadUrl => apkUrl ?? pageUrl;

  String get plainNotes {
    final text = notes
        .replaceAll('\r', '')
        .replaceAll(RegExp(r'^#+\s*', multiLine: true), '')
        .replaceAll('**', '')
        .trim();
    return text.length > 600 ? '${text.substring(0, 600)}…' : text;
  }

  static AppRelease? fromJson(Map<String, dynamic> json) {
    final tag = json['tag_name'];
    if (tag is! String || tag.isEmpty) return null;
    String? apk;
    final assets = json['assets'];
    if (assets is List) {
      for (final asset in assets) {
        if (asset is! Map) continue;
        final name = asset['name'];
        final url = asset['browser_download_url'];
        if (name is String && url is String && _apkName.hasMatch(name)) {
          apk = url;
          break;
        }
      }
    }
    return AppRelease(
      version: tag.startsWith('v') ? tag.substring(1) : tag,
      notes: json['body'] is String ? json['body'] as String : '',
      pageUrl: json['html_url'] is String
          ? json['html_url'] as String
          : 'https://github.com/',
      apkUrl: apk,
    );
  }
}
