import 'dart:async';
import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_navigator/go/go.dart';
import 'package:sisyphus/src/components/app_image_button.dart';
import 'package:sisyphus/src/components/custom_buttom_sheet.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';
import 'package:sisyphus/src/repositories/binance_repository.dart';
import 'package:sisyphus/src/utils/assets.dart';
import 'package:sisyphus/src/utils/theme.dart';
import 'package:sisyphus/src/views/home_view/components/charts_view/chart_landscape_view/chart_landscape_view.dart';
import 'package:sisyphus/src/views/home_view/components/charts_view/providers/interval_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String currentSymbol = "";

class ChartView extends ConsumerStatefulWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends ConsumerState<ChartView> {
  BinanceRepository repository = BinanceRepository();
  List<Candle> candles = [];
  WebSocketChannel? _channel;
  String currentInterval = "1m";

  List<String> symbols = [];
  String chartView = 'Trading view';

  @override
  void initState() {
    super.initState();
    fetchSymbols().then((value) {
      setState(() {
        symbols = value;
        if (symbols.isNotEmpty) fetchCandles(symbols[0], currentInterval);
      });
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  Future<List<String>> fetchSymbols() async {
    try {
      final data = await repository.fetchSymbols();
      return data;
    } catch (e) {
      return [];
    }
  }

  Future<void> fetchCandles(String symbol, String interval) async {
    _channel?.sink.close();
    setState(() {
      candles = [];
      currentInterval = interval;
    });

    try {
      final data =
          await repository.fetchCandles(symbol: symbol, interval: interval);
      _channel =
          repository.establishConnection(symbol.toLowerCase(), currentInterval);
      setState(() {
        candles = data;
        currentInterval = interval;
        currentSymbol = symbol;
      });
    } catch (e) {
      return;
    }
  }

  void updateCandlesFromSnapshot(AsyncSnapshot<dynamic> snapshot) {
    if (candles.isEmpty) return;
    if (snapshot.data != null) {
      final map = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      if (map.containsKey("k")) {
        final candleTicker = CandleTickerModel.fromJson(map);
        if (candles[0].date == candleTicker.candle.date &&
            candles[0].open == candleTicker.candle.open) {
          setState(() {
            candles[0] = candleTicker.candle;
          });
        } else if (candleTicker.candle.date.difference(candles[0].date) ==
            candles[0].date.difference(candles[1].date)) {
          setState(() {
            candles.insert(0, candleTicker.candle);
          });
        }
      }
    }
  }

  Future<void> loadMoreCandles(snapshot) async {
    try {
      final data = await repository.fetchCandles(
          symbol: currentSymbol,
          interval: currentInterval,
          endTime: candles.last.date.millisecondsSinceEpoch);
      setState(() {
        candles.addAll(data);
      });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Column(
        children: [
          _buildIntervalSelector(context),
          _buildChartControls(context),
          _buildChart(context),
        ],
      ),
    );
  }

  Widget _buildIntervalSelector(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Time'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    intervals.length,
                    (i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          fetchCandles(currentSymbol, intervals[i]);
                        },
                        child: Container(
                          width: 45,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: currentInterval == intervals[i]
                                  ? themeColor(context,
                                      lightColor: HexColor('#CFD3D8'),
                                      darkColor: HexColor('#555C63'))
                                  : null,
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            intervals[i],
                            style: TextStyle(
                              color: currentInterval == intervals[i]
                                  ? themeColor(context,
                                      lightColor: HexColor('#000000'),
                                      darkColor: HexColor('#A7B1BC'))
                                  : themeColor(context,
                                      lightColor: HexColor('#737A91'),
                                      darkColor: HexColor('#FFFFFF')),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: VerticalDivider(),
              ),
              ImageViewer(
                imagePath: AppAssets.chartIcon,
                color: themeColor(context,
                    lightColor: HexColor('#CFD3D8'),
                    darkColor: HexColor('#555C63')),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: VerticalDivider(),
              ),
              Text(
                'Fx Indicators',
                style: TextStyle(
                    color: themeColor(context,
                        lightColor: HexColor('#737A91'),
                        darkColor: HexColor('#555C63'))),
              ),
              const SizedBox(width: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartControls(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            children: [
              _chartViewButton(
                  text: 'Trading view',
                  chartView: chartView,
                  context: context,
                  onChanged: (val) {
                    setState(() {
                      chartView = 'Trading view';
                    });
                  }),
              _chartViewButton(
                  text: 'Depth',
                  chartView: chartView,
                  context: context,
                  onChanged: (val) {
                    setState(() {
                      chartView = 'Depth';
                    });
                  }),
              const SizedBox(
                width: 13,
              ),
              AppImageButton(
                onPressed: () {
                  Go(context).to(routeName: ChartLandscapeView.routeName);
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.landscapeRight]);
                },
                imagePath: AppAssets.expand,
              ),
              const SizedBox(
                width: 13,
              ),
              TextButton.icon(
                onPressed: () {
                  _showSymbolSearchSheet(context);
                },
                icon: ImageViewer(
                  imagePath: AppAssets.chartIcon,
                  fit: BoxFit.contain,
                ),
                label: Text(currentSymbol),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    return SizedBox(
      height: 409,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _channel?.stream,
        builder: (context, snapshot) {
          Timer.periodic(const Duration(milliseconds: 1), (timer) {
            updateCandlesFromSnapshot(snapshot);
          });
          return Candlesticks(
            key: Key(currentSymbol + currentInterval),
            candles: candles,
            onLoadMoreCandles: () {
              return loadMoreCandles(snapshot);
            },
          );
        },
      ),
    );
  }

  void _showSymbolSearchSheet(BuildContext context) {
    String symbolSearch = "";
    CustomBottomSheet.show(
      context: context,
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChartSymbolFilterField(
              onChanged: (value) {
                setState(() {
                  symbolSearch = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: symbols
                  .where((element) => element
                      .toLowerCase()
                      .contains(symbolSearch.toLowerCase()))
                  .map((value) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 50,
                          height: 30,
                          child: RawMaterialButton(
                            fillColor: value == currentSymbol
                                ? HexColor('#CFD3D8')
                                : null,
                            onPressed: () {
                              fetchCandles(value, currentInterval);
                              Navigator.pop(context);
                            },
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: themeColor(context,
                                      lightColor: HexColor('#000000'),
                                      darkColor: HexColor('#A7B1BC'))),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _chartViewButton({
    required String text,
    required String chartView,
    required BuildContext context,
    required Function(String) onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        onChanged(text);
      },
      child: Container(
        width: 100,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: chartView == text
              ? themeColor(context,
                  lightColor: HexColor('#CFD3D8'),
                  darkColor: HexColor('#555C63'))
              : null,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: chartView == text
                ? themeColor(context,
                    lightColor: HexColor('#000000'),
                    darkColor: HexColor('#FFFFFF'))
                : HexColor('#737A91'),
          ),
        ),
      ),
    );
  }
}

class ChartSymbolFilterField extends StatelessWidget {
  const ChartSymbolFilterField({super.key, required this.onChanged});

  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      cursorColor: themeColor(context,
          darkColor: HexColor('#F1F1F1'), lightColor: HexColor('#000000')),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: themeColor(context,
              darkColor: HexColor('#F1F1F1'), lightColor: HexColor('#000000')),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
              width: 1,
              color: themeColor(context,
                  darkColor: HexColor('#F1F1F1'),
                  lightColor: HexColor('#000000'))),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
              width: 1,
              color: themeColor(context,
                  darkColor: HexColor('#F1F1F1'),
                  lightColor: HexColor('#000000'))),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
              width: 1,
              color: themeColor(context,
                  darkColor: HexColor('#F1F1F1'),
                  lightColor: HexColor('#000000'))),
        ),
      ),
      onChanged: onChanged,
    );
  }
}

class CandleTickerModel {
  final int eventTime;
  final String symbol;
  final Candle candle;

  const CandleTickerModel({
    required this.eventTime,
    required this.symbol,
    required this.candle,
  });

  factory CandleTickerModel.fromJson(Map<String, dynamic> json) {
    return CandleTickerModel(
      eventTime: json['E'] as int,
      symbol: json['s'] as String,
      candle: Candle(
        date: DateTime.fromMillisecondsSinceEpoch(json["k"]["t"]),
        high: double.parse(json["k"]["h"]),
        low: double.parse(json["k"]["l"]),
        open: double.parse(json["k"]["o"]),
        close: double.parse(json["k"]["c"]),
        volume: double.parse(json["k"]["v"]),
      ),
    );
  }
}

Widget _chartViewButton({
  required String text,
  required String chartView,
  required BuildContext context,
  required Function(String) onChanged,
}) {
  return GestureDetector(
    onTap: () {
      onChanged(text);
    },
    child: Container(
      width: 100,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: chartView == text
            ? themeColor(context,
                lightColor: HexColor('#CFD3D8'), darkColor: HexColor('#555C63'))
            : null,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: chartView == text
              ? themeColor(context,
                  lightColor: HexColor('#000000'),
                  darkColor: HexColor('#FFFFFF'))
              : HexColor('#737A91'),
        ),
      ),
    ),
  );
}
