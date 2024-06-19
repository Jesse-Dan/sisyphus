import 'package:flutter/material.dart';
import 'package:sisyphus/src/utils/components/app_card.dart';
import 'package:sisyphus/src/utils/components/custom_tab_bar.dart';
import 'package:sisyphus/src/utils/components/custom_tab_bar_b.dart';
import 'package:sisyphus/src/utils/dimentions.dart';
import 'package:sisyphus/src/views/home_view/components/buttom_actions_buttons.dart';
import 'package:sisyphus/src/views/home_view/components/charts_view/chart_view.dart';
import 'package:sisyphus/src/views/home_view/components/orders/custom_order_appbar.dart';
import 'package:sisyphus/src/views/home_view/components/orders/open_orders.dart';
import 'package:sisyphus/src/views/home_view/components/top_section.dart';

import 'components/orders/order_book.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _tabControllerB;

  final _tabs = [
    const Tab(text: 'Open Orders'),
    const Tab(text: 'Positions'),
    const Tab(text: 'Order History'),
    const Tab(text: 'Trade History'),
  ];

  final _iconTabs = [
    const OpenOrders(),
    const Tab(icon: Icon(Icons.search)),
    const Tab(icon: Icon(Icons.settings)),
    const Tab(icon: Icon(Icons.settings)),
  ];

  final _tabsB = [
    const Tab(text: 'Charts'),
    const Tab(text: 'Orderbook'),
    const Tab(text: 'Recent trades'),
  ];

  final _iconTabsB = [
    const ChartView(),
    const OrderBook(),
    const Tab(icon: Icon(Icons.settings)),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabControllerB = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _tabControllerB.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: Dimentions.kSmallSpacing),
            topSection(),
            const SizedBox(height: Dimentions.kSmallSpacing),
            AppCard(
              height: 600,
              child: tabBarBWidget(_tabControllerB, _tabsB, _iconTabsB),
            ),
            const SizedBox(height: Dimentions.kSmallSpacing),
            AppCard(
              addBorder: false,
              height: 559,
              child: tabBarWidget(_tabController, _tabs, _iconTabs),
            ),
             actionButtonsWidget(context)
          ],
        ),
      ),
    );
  }
}

Widget tabBarBWidget(
    TabController tabControllerB, List<Tab> tabsB, List<Widget> iconTabsB) {
  return Column(
    children: [
      const SizedBox(height: Dimentions.kLargeSpacing),
      CustomTabBarB(
          tabController: tabControllerB,
          tabs: tabsB,
          physics: const NeverScrollableScrollPhysics()),
      Expanded(
        child: TabBarView(
          controller: tabControllerB,
          children: iconTabsB,
        ),
      ),
    ],
  );
}

Widget tabBarWidget(
    TabController tabController, List<Tab> tabs, List<Widget> iconTabs) {
  return Column(
    children: [
      const SizedBox(height: Dimentions.kLargeSpacing),
      CustomTabBar(tabController: tabController, tabs: tabs),
      Expanded(
        child: TabBarView(
          controller: tabController,
          children: iconTabs,
        ),
      ),
    ],
  );
}

Widget topSection() {
  return const TopSection();
}
