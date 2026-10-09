// author: juraj.suchan@gmail.com

class SharedContent {
  const SharedContent({
    this.text,
    this.imagePath,
    this.name,
    this.isImage = false,
  });

  final String? text;
  final String? imagePath;
  final String? name;
  final bool isImage;

  static SharedContent? fromChannel(Object? raw) {
    if (raw is! Map) return null;
    final type = raw['type'];
    if (type == 'image') {
      return SharedContent(
        isImage: true,
        imagePath: raw['path'] as String?,
        name: raw['name'] as String?,
      );
    }
    final text = raw['text'];
    if (type == 'text' && text is String) return SharedContent(text: text);
    return null;
  }
}
