import 'dart:convert';

class NotificationData {
  int id;
  String title;
  String content;
  bool isRead;
  
  NotificationData({
    this.id,
    this.title,
    this.content,
    this.isRead,
  });

  NotificationData copyWith({
    int id,
    String title,
    String content,
    bool isRead,
  }) {
    return NotificationData(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'isRead': isRead,
    };
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return NotificationData(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      isRead: map['isRead'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationData.fromJson(String source) => NotificationData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationData(id: $id, title: $title, content: $content, isRead: $isRead)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is NotificationData &&
      o.id == id &&
      o.title == title &&
      o.content == content &&
      o.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      isRead.hashCode;
  }
}
