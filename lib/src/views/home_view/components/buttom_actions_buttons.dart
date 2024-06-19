// ignore_for_file: unused_field

import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:sisyphus/src/components/custom_buttom_sheet.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';
import 'package:sisyphus/src/utils/assets.dart';
import 'package:sisyphus/src/utils/components/app_button.dart';
import 'package:sisyphus/src/utils/components/app_card.dart';
import 'package:sisyphus/src/utils/dimentions.dart';
import 'package:sisyphus/src/views/components/charts_tab_view/custom_tab_view.dart';

import 'charts_tab_view/tabs/buy.dart';
import 'charts_tab_view/tabs/sell.dart';

Widget actionButtonsWidget(BuildContext context) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: AppButton(
              btnColor: HexColor('#25C26E'),
              btnText: 'Buy',
              onTap: () {
                CustomBottomSheet.show(
                  context: context,
                  content: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTabView(
                            tabs: ['Buy', 'Sell'],
                            tabContents: [BuyTab(), SellTab()],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: Dimentions.kLargeSpacing),
          Flexible(
            child: AppButton(
              btnColor: HexColor('#FF554A'),
              btnText: 'Sell',
            ),
          ),
        ],
      ),
    ),
  );
}

Widget depositFieldBox(DepositDataModel? dataModel) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(dataModel?.title ?? '',
              style: TextStyle(color: HexColor('#A7B1BC'))),
          Visibility(
            visible: dataModel?.imagePath != null,
            child: ImageViewer(
              imagePath: dataModel?.imagePath ?? AppAssets.clock,
              color: HexColor('#A7B1BC'),
            ),
          ),
        ],
      ),
      const SizedBox(height: Dimentions.kSmallSpacing),
      Text(
        dataModel?.value ?? '',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      ),
    ],
  );
}

Widget bottomActionsWidget(BuildContext context) {
  return AppCard(
    height: 64,
    addBorder: true,
    color: Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).scaffoldBackgroundColor
        : HexColor('#FFFFFF'),
    child: Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimentions.kMediumSpacing),
      child: actionButtonsWidget(context),
    ),
  );
}

class DepositDataModel {
  final String title;
  final String? value;
  final String? imagePath;

  DepositDataModel({
    required this.title,
    this.value,
    this.imagePath,
  });

  static Map<String, DepositDataModel> data = {
    'account': DepositDataModel(
      title: 'Total account value',
      value: '0.00',
    ),
    'country': DepositDataModel(title: 'NGN', imagePath: AppAssets.dropdown),
    'open_order': DepositDataModel(
      title: 'Open Orders',
      value: '0.00',
    ),
    'available': DepositDataModel(
      title: 'Available',
      value: '0.00',
    ),
  };
}
