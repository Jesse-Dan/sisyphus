import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:sisyphus/src/components/app_image_button.dart';
import 'package:sisyphus/src/utils/theme.dart';

/// A reusable widget that represents an image button inside a styled container.
///
/// The container's background color and border radius are customizable.
/// When the button is pressed, it executes a specified callback function.
class StyledImageButton extends StatelessWidget {
  /// The path to the image displayed on the button.
  final String imagePath;

  /// The callback function executed when the button is pressed.
  final VoidCallback onPressed;

  /// The condition to determine the background color of the container.
  final bool isSelected;

  /// The height of the container.
  final double height;

  /// The width of the container.
  final double width;

  /// The border radius of the container.
  final double borderRadius;

  const StyledImageButton({
    Key? key,
    required this.imagePath,
    required this.onPressed,
    this.isSelected = false,
    this.height = 35,
    this.width = 35,
    this.borderRadius = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isSelected
            ? themeColor(context,
                lightColor: HexColor('#CFD3D8'), darkColor: HexColor('#353945'))
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: AppImageButton(
        imagePath: imagePath,
        onPressed: onPressed,
      ),
    );
  }
}
