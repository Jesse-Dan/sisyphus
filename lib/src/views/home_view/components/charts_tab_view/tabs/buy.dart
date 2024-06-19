import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';
import 'package:sisyphus/src/utils/assets.dart';
import 'package:sisyphus/src/utils/components/app_button.dart';
import 'package:sisyphus/src/utils/components/custom_text_field.dart';
import 'package:sisyphus/src/utils/dimentions.dart';
import 'package:sisyphus/src/utils/theme.dart';
import 'package:sisyphus/src/views/home_view/components/buttom_actions_buttons.dart';

class BuyTab extends ConsumerStatefulWidget {
  const BuyTab({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyTabState();
}

class _BuyTabState extends ConsumerState<BuyTab> {
  List<String> clips = ['Limit', 'Market', 'Stop-Limit'];

  TextEditingController limitCtl = TextEditingController();
  TextEditingController amountCtl = TextEditingController();
  TextEditingController typeCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final selectedMarker = ref.watch(marketMarkerProvider);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  clips.length,
                  (i) => GestureDetector(
                        onTap: () {
                          ref.read(marketMarkerProvider.notifier).setTab(i);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          constraints: const BoxConstraints(minWidth: 100),
                          decoration: BoxDecoration(
                              color: selectedMarker != i
                                  ? null
                                  : themeColor(context,
                                      lightColor: HexColor('#CFD3D8'),
                                      darkColor: HexColor('#353945')),
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            clips[i],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: selectedMarker != i
                                        ? null
                                        : FontWeight.w700),
                          ),
                        ),
                      ))),
          const SizedBox(height: Dimentions.kXLargeSpacing),
          CustomTextField(
            key: const Key('1'),
            limitCtl,
            suffixString: ('0.00 USD', () {}),
            prefixString: ('Limit price', () {}),
          ),
          const SizedBox(
            height: Dimentions.kXLargeSpacing,
          ),
          CustomTextField(
            key: const Key('2'),
            amountCtl,
            suffixString: ('0.00 USD', () {}),
            prefixString: ('Amount', () {}),
          ),
          const SizedBox(height: Dimentions.kXLargeSpacing),
          CustomTextField(
            key: const Key('3'),
            typeCtl,
            suffix: (
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Good till cancelled',
                      style: TextStyle(color: HexColor('#A7B1BC')),
                    ),
                    const SizedBox(width: Dimentions.kSmallSpacing),
                    ImageViewer(
                      imagePath: AppAssets.dropdown,
                      color: HexColor('#A7B1BC'),
                      height: 12,
                      width: 12,
                    )
                  ],
                ),
              ),
              () {}
            ),
            prefixString: ('Type', () {}),
          ),
          const SizedBox(height: Dimentions.kXLargeSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: HexColor('#A7B1BC'), width: 1),
                ),
                activeColor: HexColor('#2764FF'),
                value: ref.watch(checked),
                onChanged: (_) {
                  ref.read(checked.notifier).check(_ ?? false);
                },
              ),
              const SizedBox(width: Dimentions.kSmallSpacing),
              Text(
                'Post Only',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: HexColor('#A7B1BC')),
              ),
              const SizedBox(width: Dimentions.kSmallSpacing),
              ImageViewer(
                imagePath: AppAssets.indicatorIcon,
                color: HexColor('#A7B1BC'),
                height: 16,
                width: 16,
              )
            ],
          ),
          const SizedBox(height: Dimentions.kXLargeSpacing),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: HexColor('#A7B1BC')),
              ),
              Text(
                '0.00',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: HexColor('#A7B1BC')),
              ),
            ],
          ),
          const SizedBox(height: Dimentions.kXLargeSpacing),
          AppButton(
            gradient: LinearGradient(colors: [
              HexColor('#483BEB'),
              HexColor('#7847E1'),
              HexColor('#DD568D')
            ]),
            btnText: 'Buy BTC',
            onTap: () {},
          ),
          const SizedBox(height: Dimentions.kXLargeSpacing),
          Divider(
            color: HexColor('#394047').withOpacity(.7),
          ),
          const SizedBox(height: Dimentions.kXLargeSpacing),
          Row(
            children: [
              DepositFieldBox(
                dataModel: DepositDataModel.data['account'],
              ),
              const Spacer(),
              DepositFieldBox(
                dataModel: DepositDataModel.data['country'],
              )
            ],
          ),
          const SizedBox(height: Dimentions.kXLargeSpacing),
          Row(
            children: [
              DepositFieldBox(
                dataModel: DepositDataModel.data['open_order'],
              ),
              const Spacer(),
              DepositFieldBox(
                dataModel: DepositDataModel.data['available'],
              )
            ],
          ),
          const SizedBox(height: Dimentions.kXLargeSpacing * 2),
          AppButton(
            width: 89,
            btnTextColor: themeColor(context,
                lightColor: HexColor('#FFFFFF'),
                darkColor: HexColor('#FFFFFF')),
            btnColor: HexColor('#2764FF'),
            btnText: 'Deposit',
            onTap: () {},
          )
        ],
      ),
    );
  }
}

/// A Riverpod provider for managing the selected tab index.
final marketMarkerProvider =
    StateNotifierProvider<MarketMarkersNotifier, int>((ref) {
  return MarketMarkersNotifier();
});

/// A notifier class for managing the state of the selected tab index.
class MarketMarkersNotifier extends StateNotifier<int> {
  MarketMarkersNotifier() : super(0);

  /// Sets the selected tab index to [index].
  void setTab(int index) {
    state = index;
  }
}

/// A Riverpod provider for managing the selected tab index.
final checked = StateNotifierProvider<CheckBoxNotifier, bool>((ref) {
  return CheckBoxNotifier();
});

/// A notifier class for managing the state of the selected tab index.
class CheckBoxNotifier extends StateNotifier<bool> {
  CheckBoxNotifier() : super(false);

  /// Sets the selected tab index to [index].
  void check(bool index) {
    state = index;
  }
}

class DepositFieldBox extends StatelessWidget {
  final DepositDataModel? dataModel;

  const DepositFieldBox({
    super.key,
    required this.dataModel,
  });

  @override
  Widget build(BuildContext context) {
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
                ))
          ],
        ),
        const SizedBox(height: Dimentions.kSmallSpacing),
        Text(dataModel?.value ?? '',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
      ],
    );
  }
}
