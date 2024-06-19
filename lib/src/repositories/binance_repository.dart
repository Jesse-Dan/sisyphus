import 'dart:convert';
import 'dart:developer';

import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceRepository {
  Future<List<Candle>> fetchCandles(
      {required String symbol, required String interval, int? endTime}) async {
    log('fetchCandles');

    final uri = Uri.parse(
        "https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval${endTime != null ? "&endTime=$endTime" : ""}");
    final res = await http.get(uri);
    log(res.toString());
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => Candle.fromJson(e))
        .toList()
        .reversed
        .toList();
  }

  Future<List<String>> fetchSymbols() async {
    log('fetchSymbols');

    final uri = Uri.parse("https://api.binance.com/api/v3/ticker/price");
    log('fetchSymbols - url');

    final res = await http.get(uri);

    // // log('fetchSymbols - $res');

    // var r =
    //     "[{'symbol':'XXRPPP'},{'symbol':'XXRPPP'},{'symbol':'XXRPPP'},{'symbol':'XXRPPP'},{'symbol':'XXRPPP'},{'symbol':'XXRPPP'}]";

    var fr = (jsonDecode(res.body) as List<dynamic>)
        .map((e) => e["symbol"] as String)
        .toList();

    log('fetchSymbols - fr - $fr');

    return fr;
  }

  WebSocketChannel establishConnection(String symbol, String interval) {
    log('establishConnection');

    final channel = WebSocketChannel.connect(
      Uri.parse('wss://stream.binance.com:9443/ws'),
    );
    channel.sink.add(
      jsonEncode(
        {
          "method": "SUBSCRIBE",
          "params": ["$symbol@kline_$interval"],
          "id": 1
        },
      ),
    );
    return channel;
  }
}

