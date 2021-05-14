import 'dart:convert';

class UomData {
  int id;
  String unit;
  int value;
  double weight;
  double height;
  double width;
  double length;

  UomData({
    this.id,
    this.unit,
    this.value,
    this.weight,
    this.height,
    this.width,
    this.length,
  });

  UomData copyWith({
    int id,
    String unit,
    int value,
    double weight,
    double height,
    double width,
    double length,
  }) {
    return UomData(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      value: value ?? this.value,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      width: width ?? this.width,
      length: length ?? this.length,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'unit': unit,
      'value': value,
      'weight': weight,
      'height': height,
      'width': width,
      'length': length,
    };
  }

  factory UomData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UomData(
      id: map['id'],
      unit: map['unit'],
      value: map['value'],
      weight: map['weight'],
      height: map['height'],
      width: map['width'],
      length: map['length'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UomData.fromJson(String source) => UomData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UomData(id: $id, unit: $unit, value: $value, weight: $weight, height: $height, width: $width, length: $length)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UomData &&
      o.id == id &&
      o.unit == unit &&
      o.value == value &&
      o.weight == weight &&
      o.height == height &&
      o.width == width &&
      o.length == length;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      unit.hashCode ^
      value.hashCode ^
      weight.hashCode ^
      height.hashCode ^
      width.hashCode ^
      length.hashCode;
  }
}
