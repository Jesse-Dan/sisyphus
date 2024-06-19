import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Color? btnColor;
  final Color? btnTextColor;
  final String btnText;

  final Function()? onTap;
  final bool isLoading;
  final Gradient? gradient;

  final double? width;

  const AppButton(
      {super.key,
      this.btnColor,
      this.btnTextColor,
      this.onTap,
      this.isLoading = false,
      this.btnText = '',
      this.gradient,
      this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            color: gradient != null ? null : btnColor,
            borderRadius: BorderRadius.circular(8),
            gradient: gradient),
        child: Text(
          btnText,
          style: TextStyle(fontWeight: FontWeight.w700, color: btnTextColor),
        ),
      ),
    );
  }
}
