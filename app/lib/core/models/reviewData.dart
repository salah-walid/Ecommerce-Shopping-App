import 'dart:convert';

import 'package:ecom/core/models/userData.dart';

class ReviewData {
  int id;
  String content;
  int stars;
  UserData user;
  
  ReviewData({
    this.id,
    this.content,
    this.stars = 5,
    this.user,
  });
  

  ReviewData copyWith({
    int id,
    String content,
    int stars,
    UserData user,
  }) {
    return ReviewData(
      id: id ?? this.id,
      content: content ?? this.content,
      stars: stars ?? this.stars,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'stars': stars,
      'user': user?.toMap(),
    };
  }

  factory ReviewData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ReviewData(
      id: map['id'],
      content: map['content'],
      stars: map['stars'],
      user: UserData.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReviewData.fromJson(String source) => ReviewData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReviewData(id: $id, content: $content, stars: $stars, user: $user)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ReviewData &&
      o.id == id &&
      o.content == content &&
      o.stars == stars &&
      o.user == user;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      content.hashCode ^
      stars.hashCode ^
      user.hashCode;
  }
}
