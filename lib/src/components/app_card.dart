import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppCard extends ConsumerWidget {
  final Widget? child;
  final double height;
  final bool addBorder;
  final Color? color;

  const AppCard({
    this.child,
    super.key,
    this.height = 126,
    this.addBorder = true,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color ??
            (Theme.of(context).brightness == Brightness.dark
                ? HexColor('#17181B')
                : HexColor('#FFFFFF')),
        border: Border.symmetric(
          horizontal: BorderSide(
            width: addBorder ? 1 : 0,
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor('#262932')
                : HexColor('#F1F1F1'),
          ),
        ),
      ),
      child: Align(alignment: Alignment.center, child: child),
    );
  }
}
