import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_navigator/go/go.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';
import 'package:sisyphus/src/utils/assets.dart';
import 'package:sisyphus/src/utils/components/app_image_button.dart';
import 'package:sisyphus/src/utils/theme.dart';
import 'package:sisyphus/src/views/asset_view/asset_view.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: _buildLeadingImage(context, ref),
      leadingWidth: 121,
      actions: _buildActions(context, ref),
    );
  }

  Widget _buildLeadingImage(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final imagePath =
        theme == ThemeMode.light ? AppAssets.blackLogo : AppAssets.whiteLogo;

    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: ImageViewer(
        imagePath: imagePath,
        height: 34,
        width: 121,
        fit: BoxFit.contain,
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, WidgetRef ref) {
    return [
      AppImageButton(
        imagePath: AppAssets.person,
        onPressed: () => Go(context).to(routeName: AssetsView.routeName),
      ),
      AppImageButton(
        imagePath: AppAssets.web,
        onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
      ),
      _buildPopupMenu(context, ref),
    ];
  }

  Widget _buildPopupMenu(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<int>(
      icon: ImageViewer(imagePath: AppAssets.menu),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child:
              _buildPopupMenuItem(Icons.currency_exchange_outlined, "Exchange"),
        ),
        PopupMenuItem(
          value: 2,
          child: _buildPopupMenuItem(Icons.wallet, "Wallets"),
        ),
        PopupMenuItem(
          value: 3,
          child: _buildPopupMenuItem(Icons.hub, "Roqqu Hub"),
        ),
        PopupMenuItem(
          onTap: () {
            ref.read(themeProvider.notifier).toggleTheme();
          },
          value: 4,
          child: _buildPopupMenuItem(Icons.color_lens_sharp, "Toggle Theme"),
        ),
        PopupMenuItem(
          onTap: () {
            Go(context).to(routeName: AssetsView.routeName);
          },
          value: 5,
          child: _buildPopupMenuItem(Icons.view_array, "App Assets"),
        ),
        PopupMenuItem(
          value: 6,
          child: _buildPopupMenuItem(Icons.chrome_reader_mode, "Log out "),
        ),
      ],
      elevation: 0,
      offset: const Offset(40, 60),
    );
  }

  static Widget _buildPopupMenuItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(text),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
