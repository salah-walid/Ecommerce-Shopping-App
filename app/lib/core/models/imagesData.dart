import 'dart:convert';

class ImageData {
  String title;
  String image;
  ImageData({
    this.title,
    this.image,
  });

  ImageData copyWith({
    String title,
    String image,
  }) {
    return ImageData(
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
    };
  }

  factory ImageData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ImageData(
      title: map['title'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageData.fromJson(String source) => ImageData.fromMap(json.decode(source));

  @override
  String toString() => 'ImageData(title: $title, image: $image)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ImageData &&
      o.title == title &&
      o.image == image;
  }

  @override
  int get hashCode => title.hashCode ^ image.hashCode;
}
