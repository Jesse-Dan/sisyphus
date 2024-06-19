import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';
import 'package:sisyphus/src/utils/assets.dart';
import 'package:sisyphus/src/utils/theme.dart';
import 'package:sisyphus/src/views/home_view/components/styled_image_button.dart';
import 'package:sisyphus/src/views/home_view/providers/order_book_provider.dart';
import '../../../../utils/dimentions.dart';

var selectedItemProvider = StateProvider<String?>((ref) => '10');

var globalFormKeyProvider =
    StateProvider<GlobalKey<FormState>>((ref) => GlobalKey<FormState>());

class OrderBook extends ConsumerWidget {
  const OrderBook({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var order = ref.watch(currentOrderBookFormatProvider);
    var orderNotifier = ref.watch(currentOrderBookFormatProvider.notifier);

    Widget _buildChartText(String text, String color, TextAlign align) {
      return Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: HexColor(color),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
        textAlign: align,
      );
    }

    Widget _buildMiddleText(String text, Color color) {
      return Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
      );
    }

    Widget _buildButtons(WidgetRef ref, order, orderNotifier) {
      return Row(
        children: [
          StyledImageButton(
            imagePath: AppAssets.priceViewRBG,
            onPressed: () => orderNotifier.setOrderBookFormat('RBG'),
            isSelected: order.refName == 'RBG',
          ),
          StyledImageButton(
            imagePath: AppAssets.priceViewBBG,
            onPressed: () => orderNotifier.setOrderBookFormat('BBG'),
            isSelected: order.refName == 'BBG',
          ),
          StyledImageButton(
            imagePath: AppAssets.priceViewRBB,
            onPressed: () => orderNotifier.setOrderBookFormat('RBB'),
            isSelected: order.refName == 'RBB',
          ),
          const Spacer(),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: themeColor(context,
                  lightColor: HexColor('#CFD3D8'),
                  darkColor: HexColor('#353945')),
              borderRadius: BorderRadius.circular(4),
            ),
            child: _dropDown(ref, context,
                icon: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.keyboard_arrow_down_rounded),
                )),
          ),
        ],
      );
    }

    Widget _buildChart() {
      return Expanded(
        child: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
              height: 35,
              width: double.infinity,
              child: Row(
                children: [
                  _buildChartText('Price\n(USDT)', '#A7B1BC', TextAlign.center),
                  const Spacer(),
                  _buildChartText('Amounts\n(BTC)', '#A7B1BC', TextAlign.end),
                  const Spacer(),
                  _buildChartText('Total', '#A7B1BC', TextAlign.end),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                height: 200,
                width: double.infinity,
                child: ListView(
                  shrinkWrap: false,
                  physics: const NeverScrollableScrollPhysics(),
                  children: ChartRow.chartSellsRows,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              width: double.infinity,
              child: Wrap(
                children: [
                  _buildMiddleText('36,641.20', HexColor('#25C26E')),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ImageViewer(
                      imagePath: AppAssets.high,
                      color: HexColor('#25C26E'),
                    ),
                  ),
                  _buildMiddleText(
                      '36,641.20',
                      themeColor(context,
                          lightColor: HexColor('#1C2127'),
                          darkColor: HexColor('#FCFCFD'))),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 170,
                width: double.infinity,
                child: ListView(
                  shrinkWrap: false,
                  physics: const NeverScrollableScrollPhysics(),
                  children: ChartRow.chartBuyRows,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: Dimentions.kLargeSpacing),
            _buildButtons(ref, order, orderNotifier),
            const SizedBox(height: 20),
            _buildChart(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

final List<String> _fruits = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10'
];

/// A reusable dropdown button widget with customizable parameters.
///
/// The dropdown button allows for selection from a list of fruits. It includes
/// optional customization for the underline, icon, text style, hint style,
/// dropdown color, and icon enabled color.
Widget _dropDown(
  WidgetRef ref,
  BuildContext context, {
  Widget? underline = const SizedBox.shrink(),
  Widget? icon,
  TextStyle? style,
  TextStyle? hintStyle,
  Color? dropdownColor,
  Color? iconEnabledColor,
}) =>
    DropdownButton<String>(
      borderRadius: BorderRadius.circular(8),
      focusColor: const Color(0xFF353945),
      elevation: 2,
      value: ref.watch(selectedItemProvider),
      underline: underline,
      icon: icon,
      dropdownColor: (Theme.of(context).brightness == Brightness.dark
          ? HexColor('#17181B')
          : HexColor('#FFFFFF')),
      style: style,
      iconEnabledColor: iconEnabledColor,
      onChanged: (String? newValue) {
        ref.watch(selectedItemProvider.notifier).state = newValue;
      },
      items: _fruits
          .map((fruit) => DropdownMenuItem<String>(
                value: fruit,
                child: Text(fruit),
              ))
          .toList(),
      selectedItemBuilder: (BuildContext context) {
        return _fruits.map<Widget>((String item) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 50),
            child: Text(item),
          );
        }).toList();
      },
    );

class ChartRow extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String thirdText;
  final Color fillColor;
  final double fillPercent;

  const ChartRow(
      {super.key,
      required this.firstText,
      required this.secondText,
      required this.thirdText,
      required this.fillColor,
      required this.fillPercent});

  static List<ChartRow> chartBuyRows = [
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#25C26E'),
      fillPercent: 0.6,
    ),
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#25C26E'),
      fillPercent: 0.45,
    ),
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#25C26E'),
      fillPercent: 0.3,
    ),
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#25C26E'),
      fillPercent: 0.0,
    ),
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#25C26E'),
      fillPercent: 0.45,
    )
  ];

  static List<ChartRow> chartSellsRows = [
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#FF6838'),
      fillPercent: 0.3,
    ),
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#FF6838'),
      fillPercent: 0.0,
    ),
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#FF6838'),
      fillPercent: 0.4,
    ),
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#FF6838'),
      fillPercent: 0.0,
    ),
    ChartRow(
      firstText: '36920.12',
      secondText: '0.758965',
      thirdText: '28,020.98',
      fillColor: HexColor('#FF6838'),
      fillPercent: 0.65,
    )
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: double.infinity,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            height: 28,
            width: (fillPercent * MediaQuery.of(context).size.width),
            color: fillColor.withOpacity(.3),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
            height: 28,
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  firstText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: (fillColor),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  secondText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: themeColor(context,
                          lightColor: HexColor('#1C2127'),
                          darkColor: HexColor('#FCFCFD')),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  thirdText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: themeColor(context,
                          lightColor: HexColor('#1C2127'),
                          darkColor: HexColor('#FCFCFD')),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
