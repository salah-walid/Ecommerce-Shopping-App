import 'dart:convert';

class VariationOptions {
  int id;
  String content;
  VariationOptions({
    this.id,
    this.content,
  });

  VariationOptions copyWith({
    int id,
    String content,
  }) {
    return VariationOptions(
      id: id ?? this.id,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }

  factory VariationOptions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return VariationOptions(
      id: map['id'],
      content: map['content'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VariationOptions.fromJson(String source) => VariationOptions.fromMap(json.decode(source));

  @override
  String toString() => 'VariationOptions(id: $id, content: $content)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is VariationOptions &&
      o.id == id &&
      o.content == content;
  }

  @override
  int get hashCode => id.hashCode ^ content.hashCode;
}
