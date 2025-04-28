class Sticker {
  final String path;
  final String type;
  final bool isPro;

  const Sticker({required this.path, required this.type, this.isPro = false});

  factory Sticker.fromMap(Map<String, Object?> map) {
    return Sticker(
        path: map['path'] as String? ?? '',
        type: map['type'] as String? ?? '',
        isPro: map['isPro'] as bool? ?? false);
  }

  Map<String, Object?> toMap() {
    return {
      'path': path,
      'type': type,
      'isPro': isPro,
    };
  }
}
