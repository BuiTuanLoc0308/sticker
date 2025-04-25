class Sticker {
  final String path;
  final String type;

  const Sticker({required this.path, required this.type});

  factory Sticker.fromMap(Map<String, String> map) {
    return Sticker(
      path: map['path'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'path': path,
      'type': type,
    };
  }
}
