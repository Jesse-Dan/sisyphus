import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sisyphus/src/helpers/Image_viewer/enums/image_resize_mode.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.cover,
    this.resizeMode = ImageResizeMode.cover,
    this.borderRadius,
  });

  final String imagePath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final ImageResizeMode resizeMode;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double? imageWidth;
        double? imageHeight;

        switch (resizeMode) {
          case ImageResizeMode.cover:
            if (width != null && height != null) {
              if (constraints.maxWidth / width! >
                  constraints.maxHeight / height!) {
                imageWidth = constraints.maxWidth;
                imageHeight = height! * imageWidth / width!;
              } else {
                imageHeight = constraints.maxHeight;
                imageWidth = width! * imageHeight / height!;
              }
            }
            break;
          case ImageResizeMode.contain:
            if (width != null && height != null) {
              if (constraints.maxWidth / width! <
                  constraints.maxHeight / height!) {
                imageWidth = constraints.maxWidth;
                imageHeight = height! * imageWidth / width!;
              } else {
                imageHeight = constraints.maxHeight;
                imageWidth = width! * imageHeight / height!;
              }
            }
            break;
          case ImageResizeMode.stretch:
            imageWidth = constraints.maxWidth;
            imageHeight = constraints.maxHeight;
            break;
        }

        Widget getImageWidget() {
          if (imagePath.endsWith('.svg')) {
            return SvgPicture.asset(
              imagePath,
              width: width,
              height: height,
              color: color,
              fit: fit,
            );
          } else if (imagePath.contains('http')) {
            return Image.network(
              imagePath,
              width: width,
              height: height,
              color: color,
              fit: fit,
            );
          } else {
            return Image.asset(
              imagePath,
              width: width,
              height: height,
              color: color,
              fit: fit,
            );
          }
        }

        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(0.0),
          child: SizedBox(
            width: width,
            height: height,
            child: getImageWidget(),
          ),
        );
      },
    );
  }
}
