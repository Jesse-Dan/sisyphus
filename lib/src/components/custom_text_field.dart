import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';
import 'package:sisyphus/src/utils/assets.dart';
import 'package:sisyphus/src/utils/theme.dart';

class CustomTextField extends ConsumerWidget {
  final TextEditingController textController;
  final (Widget, VoidCallback)? suffix;
  final (Widget, VoidCallback)? prefix;

  final (String, VoidCallback)? suffixString;
  final (String, VoidCallback)? prefixString;
  final void Function(String)? onChanged;

  const CustomTextField(
    this.textController, {
    this.suffix,
    this.prefix,
    this.suffixString,
    this.prefixString,
    super.key,
    this.onChanged, 
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var typing = ref.watch(typingProvider);
    final focusNode = FocusNode();

    focusNode.addListener(() {
      ref.read(typingProvider.notifier).setTyping(focusNode.hasFocus);
    });

    textController.addListener(() {
      ref
          .read(typingProvider.notifier)
          .setTyping(textController.text.isNotEmpty);
    });

    return TextFormField(
      onChanged: onChanged,
      controller: textController,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: suffix?.$1 ??
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    suffixString?.$1 ?? '',
                    style: TextStyle(color: HexColor('#A7B1BC')),
                  ),
                ],
              ),
            ),
        prefixIcon: typing
            ? null
            : prefix?.$1 ??
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        prefixString?.$1 ?? '',
                        style: TextStyle(color: HexColor('#A7B1BC')),
                      ),
                      const SizedBox(width: 8),
                      ImageViewer(
                        imagePath: AppAssets.indicatorIcon,
                        height: 16,
                        width: 16,
                        color: HexColor('#A7B1BC'),
                      )
                    ],
                  ),
                ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: themeColor(context,
                  darkColor: HexColor('#373B3F'),
                  lightColor: HexColor('#F1F1F1'))),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: themeColor(context,
                  darkColor: HexColor('#373B3F'),
                  lightColor: HexColor('#F1F1F1'))),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: themeColor(context,
                  darkColor: HexColor('#373B3F'),
                  lightColor: HexColor('#F1F1F1'))),
        ),
        fillColor: const Color(0xFF21262C),
        filled: false,
      ),
    );
  }
}

final typingProvider =
    StateNotifierProvider<TypingNotifier, bool>((ref) => TypingNotifier());

class TypingNotifier extends StateNotifier<bool> {
  TypingNotifier() : super(false);

  void setTyping(bool isTyping) {
    state = isTyping;
  }
}
