import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';

import '../dimentions.dart';

class CustomTabBarB extends StatelessWidget {
  final TabController tabController;
  final List<Tab> tabs;
  final ScrollPhysics? physics;

  const CustomTabBarB(
      {super.key,
      required this.tabController,
      required this.tabs,
      this.physics});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: Dimentions.kSmallSpacing),
          Container(
            height: kToolbarHeight - 8.0,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor('#1C2127').withOpacity(.29)
                    : HexColor('#F1F1F1'),
                borderRadius: BorderRadius.circular(10),
                border: Theme.of(context).brightness == Brightness.dark
                    ? Border.all(
                        color: HexColor('#262932').withOpacity(.7), width: 1.5)
                    : null),
            child: TabBar(
              physics: physics,
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              indicatorPadding:
                  const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
              tabs: tabs,
              labelPadding: const EdgeInsets.symmetric(horizontal: 35),
            ),
          ),
          const SizedBox(width: Dimentions.kSmallSpacing),
        ],
      ),
    );
  }
}
