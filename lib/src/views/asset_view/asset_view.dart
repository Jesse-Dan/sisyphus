import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisyphus/src/utils/assets.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';
import 'package:sisyphus/src/utils/theme.dart';

class AssetsView extends ConsumerWidget {
    static const routeName = '/AssetsView';

  const AssetsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Views'),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
              icon: const Icon(Icons.thirteen_mp))
        ],
      ),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: AppAssets.assetMaps.length,
        itemBuilder: (BuildContext context, int index) {
          var assetPaths = AppAssets.assetMaps.values.toList();
          var assetsTitles = AppAssets.assetMaps.keys.toList();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageViewer(
                imagePath: assetPaths[index],
              ),
              const SizedBox(height: 20),
              Text("Asset Name: ${assetsTitles[index]}"),
              const SizedBox(height: 20),
              Text("Asset Path: ${assetPaths[index]}")
            ],
          );
        },
      ),
    );
  }
}
