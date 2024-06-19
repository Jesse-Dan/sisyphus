import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:sisyphus/src/components/app_card.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';
import 'package:sisyphus/src/utils/assets.dart';
import 'package:sisyphus/src/utils/dimentions.dart';

class TopSection extends StatelessWidget {
  const TopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
            child: Row(
              children: [
                bitcoinDollarIcons(),
                const SizedBox(width: Dimentions.kMediumSpacing),
                Text(
                  'BTC/USDT',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 18),
                ),
                const SizedBox(width: Dimentions.kLargeSpacing),
                ImageViewer(
                  imagePath: AppAssets.dropdown,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                const SizedBox(width: Dimentions.kLargeSpacing),
                priceText('\$20,634', HexColor('#00C076')),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding:
                  const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: Price.prices.length,
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: VerticalDivider(
                    color: HexColor('#EAF0FE').withOpacity(.07),
                  ),
                );
              },
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: priceItem(
                    Price.prices[i].imagePath,
                    Price.prices[i].timeFrame,
                    Price.prices[i].price,
                    Price.prices[i].priceColor,
                    context,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget bitcoinDollarIcons() {
  return SizedBox(
    height: 24,
    width: 44,
    child: Stack(
      children: [
        ImageViewer(imagePath: AppAssets.bitcoin),
        Positioned(
          right: 0,
          child: ImageViewer(imagePath: AppAssets.dollar),
        ),
      ],
    ),
  );
}

Widget priceText(String text, Color color) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: 18,
      fontFamily: 'Satoshi',
    ),
  );
}

Widget priceItem(String imagePath, String timeFrame, String price,
    Color? priceColor, BuildContext context) {
  return SizedBox(
    height: 48,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ImageViewer(imagePath: imagePath),
            SizedBox(width: Dimentions.kSmallSpacing - 2),
            Text(
              timeFrame,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: HexColor('#A7B1BC'), fontSize: 12),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(height: Dimentions.kSmallSpacing),
        Text(
          price,
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: priceColor, fontSize: 18),
        ),
      ],
    ),
  );
}

class Price {
  final String imagePath;
  final String timeFrame;
  final String price;
  final Color? priceColor;

  Price({
    required this.imagePath,
    required this.timeFrame,
    required this.price,
    this.priceColor,
  });

  static List<Price> prices = [
    Price(
        imagePath: AppAssets.time,
        timeFrame: '24h change',
        price: '520.80 +1.25%',
        priceColor: HexColor('#00C076')),
    Price(
      imagePath: AppAssets.high,
      timeFrame: '24h change',
      price: '520.80 +1.25%',
    ),
    Price(
      imagePath: AppAssets.low,
      timeFrame: '24h change',
      price: '520.80 +1.25%',
    ),
    Price(
      imagePath: AppAssets.chartIcon,
      timeFrame: '24h change',
      price: '75.655.26',
    ),
  ];
}
