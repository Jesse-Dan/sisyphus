import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var currentOrderBookFormatProvider =
    StateNotifierProvider<OrderBookNotifier, OrderBookFormat>(
        (ref) => OrderBookNotifier(OrderBookNotifier.ordersBooks.first));

class OrderBookFormat {
  final int id;
  final String refName;
  final Widget refWidget;

  const OrderBookFormat(
      {required this.id, required this.refName, required this.refWidget});
}

class OrderBookNotifier extends StateNotifier<OrderBookFormat> {
  OrderBookNotifier(super.state);

  void setOrderBookFormat(String format) {
    state =
        ordersBooks.where((order) => order.refName == format).toList().first;
  }

  static List<OrderBookFormat> ordersBooks = [
    const OrderBookFormat(id: 0, refName: 'RBG', refWidget: Center()),
    const OrderBookFormat(id: 1, refName: 'BBG', refWidget: Center()),
    const OrderBookFormat(id: 2, refName: 'RBB', refWidget: Center()),
  ];
}
