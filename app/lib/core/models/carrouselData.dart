import 'dart:convert';

class CarrouselData {
  int id;
  String title;
  String image;
  
  CarrouselData({
    this.id,
    this.title,
    this.image,
  });

  CarrouselData copyWith({
    int id,
    String title,
    String image,
  }) {
    return CarrouselData(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
    };
  }

  factory CarrouselData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CarrouselData(
      id: map['id'],
      title: map['title'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CarrouselData.fromJson(String source) => CarrouselData.fromMap(json.decode(source));

  @override
  String toString() => 'CarrouselData(id: $id, title: $title, image: $image)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is CarrouselData &&
      o.id == id &&
      o.title == title &&
      o.image == image;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ image.hashCode;
}
