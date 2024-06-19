import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';

import '../dimentions.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final List<Tab> tabs;

  const CustomTabBar({super.key, required this.tabController, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: Dimentions.kXLargeSpacing),
          Container(
            height: kToolbarHeight - 8.0,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor('#000000').withOpacity(.29)
                  : HexColor('#F1F1F1'),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorPadding:
                  const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
              tabs: tabs,
              labelPadding: const EdgeInsets.symmetric(horizontal: 35),
            ),
          ),
          const SizedBox(width: Dimentions.kXLargeSpacing),
        ],
      ),
    );
  }
}
