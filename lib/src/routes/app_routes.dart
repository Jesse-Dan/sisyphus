import 'package:flutter/material.dart';
import 'package:go_navigator/go/go_navigator.dart';
import 'package:sisyphus/src/views/asset_view/asset_view.dart';
import 'package:sisyphus/src/views/home_view/components/charts_view/chart_landscape_view/chart_landscape_view.dart';
import 'package:sisyphus/src/views/home_view/home_view.dart';

abstract class AppRoutes {
  static MaterialPageRoute<void> buildRoutes(RouteSettings settings) =>
      GoNavigator(
        initialRoute: const HomeView(),
        routes: {
          '/': (context, args) => const HomeView(),
          ChartLandscapeView.routeName: (context, args) =>
              const ChartLandscapeView(),
          AssetsView.routeName: (context, args) => const AssetsView()
        },
      ).generateRoute(settings);
}
