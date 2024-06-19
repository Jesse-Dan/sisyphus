import 'dart:async';
import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:color_system/color_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_navigator/go/go.dart';
import 'package:sisyphus/src/helpers/Image_viewer/image_viewer.dart';
import 'package:sisyphus/src/repositories/binance_repository.dart';
import 'package:sisyphus/src/utils/assets.dart';
import 'package:sisyphus/src/utils/components/custom_buttom_sheet.dart';
import 'package:sisyphus/src/utils/theme.dart';
import 'package:sisyphus/src/views/home_view/components/charts_view/chart_view.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class ChartLandscapeView extends ConsumerStatefulWidget {
  static const routeName = '/ChartLandscapeView';
  const ChartLandscapeView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChartLandscapeViewState();
}

class _ChartLandscapeViewState extends ConsumerState<ChartLandscapeView> {
  final BinanceRepository repository = BinanceRepository();
  List<Candle> candles = [];
  WebSocketChannel? _channel;
  String currentInterval = "5m";
  String currentSymbol = "BTCUSDT";
  List<String> symbols = [];

  final landscapeIntervals = [
    '5m', '15m', '30m', '1h', '2h', '4h', '6h', '8h', '12h', '1d', '3d', '1w', '1M',
  ];

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
      final data = await repository.fetchCandles(symbol: symbol, interval: interval);
      _channel = repository.establishConnection(symbol.toLowerCase(), currentInterval);
      setState(() {
        candles = data;
        currentInterval = interval;
        currentSymbol = symbol;
      });
    } catch (e) {
      // Handle error
    }
  }

  void updateCandlesFromSnapshot(AsyncSnapshot<dynamic> snapshot) {
    if (candles.isEmpty) return;
    if (snapshot.data != null) {
      final map = jsonDecode(snapshot.data as String) as Map<String, dynamic>;
      if (map.containsKey("k")) {
        final candleTicker = CandleTickerModel.fromJson(map);
        if (candles[0].date == candleTicker.candle.date && candles[0].open == candleTicker.candle.open) {
          setState(() {
            candles[0] = candleTicker.candle;
          });
        } else if (candleTicker.candle.date.difference(candles[0].date) == candles[0].date.difference(candles[1].date)) {
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
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildIntervalSelector(context),
          Expanded(
            child: StreamBuilder(
              stream: _channel?.stream,
              builder: (context, snapshot) {
                Timer.periodic(const Duration(seconds: 3), (timer) {
                  updateCandlesFromSnapshot(snapshot);
                });
                return Candlesticks(
                  key: Key(currentSymbol + currentInterval),
                  candles: candles,
                  onLoadMoreCandles: () => loadMoreCandles(snapshot),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          Go(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: ImageViewer(
          imagePath: ref.watch(themeProvider) == ThemeMode.light ? AppAssets.blackLogo : AppAssets.whiteLogo,
          height: 34,
          width: 121,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            String symbolSearch = "";
            CustomBottomSheet.show(
                context: context,
                content: _buildSymbolSearch(context, symbolSearch));
          },
          icon: ImageViewer(
            imagePath: AppAssets.chartIcon,
            fit: BoxFit.contain,
          ),
          label: Text(currentSymbol),
        )
      ],
    );
  }

  Widget _buildSymbolSearch(BuildContext context, String symbolSearch) {
    return Column(
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
                .where((element) => element.toLowerCase().contains(symbolSearch.toLowerCase()))
                .map((value) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 50,
                        height: 30,
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          fillColor: themeColor(context, lightColor: HexColor('#CFD3D8'), darkColor: HexColor('#353945')),
                          onPressed: () {
                            fetchCandles(value, currentInterval);
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                ImageViewer(height: 18, width: 18, imagePath: AppAssets.bitcoin),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: themeColor(
                                      context,
                                      lightColor: HexColor('#353945'),
                                      darkColor: HexColor('#CFD3D8'),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
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
                    landscapeIntervals.length,
                    (i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          fetchCandles(currentSymbol, landscapeIntervals[i]);
                        },
                        child: Container(
                          width: 45,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: currentInterval == landscapeIntervals[i]
                                  ? themeColor(context, lightColor: HexColor('#CFD3D8'), darkColor: HexColor('#555C63'))
                                  : null,
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            landscapeIntervals[i],
                            style: TextStyle(
                              color: currentInterval == landscapeIntervals[i]
                                  ? themeColor(context, lightColor: HexColor('#000000'), darkColor: HexColor('#A7B1BC'))
                                  : themeColor(context, lightColor: HexColor('#737A91'), darkColor: HexColor('#FFFFFF')),
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
                color: themeColor(context, lightColor: HexColor('#CFD3D8'), darkColor: HexColor('#555C63')),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: VerticalDivider(),
              ),
              Text(
                'Fx Indicators',
                style: TextStyle(
                    color: themeColor(context, lightColor: HexColor('#737A91'), darkColor: HexColor('#555C63'))),
              ),
              const SizedBox(width: 20)
            ],
          ),
        ),
      ),
    );
  }
}
