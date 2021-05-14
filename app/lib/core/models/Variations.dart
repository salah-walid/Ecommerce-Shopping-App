import 'dart:convert';

import 'package:flutter/foundation.dart';

import "VariationsOptions.dart";

class Variations {
  int id;
  String title;
  List<VariationOptions> options;
  Variations({
    this.id,
    this.title,
    this.options,
  });

  Variations copyWith({
    int id,
    String title,
    List<VariationOptions> options,
  }) {
    return Variations(
      id: id ?? this.id,
      title: title ?? this.title,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'options': options?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory Variations.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Variations(
      id: map['id'],
      title: map['title'],
      options: List<VariationOptions>.from(map['options']?.map((x) => VariationOptions.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Variations.fromJson(String source) => Variations.fromMap(json.decode(source));

  @override
  String toString() => 'Variations(id: $id, title: $title, options: $options)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Variations &&
      o.id == id &&
      o.title == title &&
      listEquals(o.options, options);
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ options.hashCode;
}
