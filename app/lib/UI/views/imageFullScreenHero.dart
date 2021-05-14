import 'package:ecom/core/models/imagesData.dart';
import 'package:flutter/material.dart';

class ImageFullScreenHero extends StatelessWidget {

  final ImageData image;

  const ImageFullScreenHero({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image.image,
      fit: BoxFit.fitWidth,
    );
  }
}