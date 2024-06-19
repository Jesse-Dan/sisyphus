import 'package:flutter/material.dart';

class CustomBottomSheet {
  /// Displays a bottom sheet with the given content.
  ///
  /// The [context] parameter is required to show the bottom sheet.
  /// The [content] parameter specifies the content to be displayed inside the bottom sheet.
  /// The [height] parameter specifies the height of the bottom sheet. If not provided, it will default to half the screen height.
  static void show({
    required BuildContext context,
    required Widget content,
    double? height,
  }) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, useState) {
          return Container(
            height: height ?? MediaQuery.of(context).size.height / 1.3,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: content,
          );
        });
      },
    );
  }
}
