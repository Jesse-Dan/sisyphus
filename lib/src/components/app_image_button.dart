import 'package:flutter/material.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';

class AppImageButton extends StatelessWidget {
  final void Function()? onPressed;
  final String imagePath;
  final Color? color;
  const AppImageButton(
      {super.key, this.onPressed, required this.imagePath, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      onPressed: onPressed,
      icon: ImageViewer(imagePath: imagePath),
    );
  }
}
