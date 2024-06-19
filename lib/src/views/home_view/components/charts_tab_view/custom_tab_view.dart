import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisyphus/src/utils/dimentions.dart';
import 'package:sisyphus/src/utils/theme.dart';

/// A reusable widget for displaying a custom tab view with animated tab transitions.
///
/// This widget uses Riverpod for state management to track the selected tab index.
/// It provides a smooth animation when switching between tabs.
///
/// The [tabs] parameter defines the list of tab names, and [tabContents] defines the corresponding tab content widgets.
class CustomTabView extends ConsumerWidget {
  final List<String> tabs;
  final List<Widget> tabContents;

  const CustomTabView({
    super.key,
    required this.tabs,
    required this.tabContents,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(tabViewProvider);

    return Column(
      children: [
        Container(
          height: 45,
          width: double.infinity,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: themeColor(context,
                lightColor: HexColor('#F1F1F1'),
                darkColor: HexColor('#000000').withOpacity(.7)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: List.generate(
              tabs.length,
              (i) => GestureDetector(
                onTap: () {
                  ref.read(tabViewProvider.notifier).setTab(i);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linearToEaseOut,
                  height: 40,
                  width: MediaQuery.of(context).size.width / tabs.length - 26,
                  decoration: BoxDecoration(
                    color: selectedTab == i
                        ? themeColor(context,
                            lightColor: HexColor('#FFFFFF'),
                            darkColor: HexColor('#21262C'))
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    border: selectedTab == i
                        ? Border.all(
                            color:
                                tabs[selectedTab].toLowerCase().contains('buy')
                                    ? HexColor('#25C26E')
                                    : tabs[selectedTab]
                                            .toLowerCase()
                                            .contains('sell')
                                        ? HexColor('#FF554A')
                                        : Colors.transparent,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[i],
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimentions.kXLargeSpacing),
        tabContents[selectedTab],
        const SizedBox(height: Dimentions.kXLargeSpacing),
      ],
    );
  }
}

/// A Riverpod provider for managing the selected tab index.
final tabViewProvider = StateNotifierProvider<TabViewNotifier, int>((ref) {
  return TabViewNotifier();
});

/// A notifier class for managing the state of the selected tab index.
class TabViewNotifier extends StateNotifier<int> {
  TabViewNotifier() : super(0);

  /// Sets the selected tab index to [index].
  void setTab(int index) {
    state = index;
  }
}
