import 'package:flutter_riverpod/flutter_riverpod.dart';


final intervalProvider =
    StateNotifierProvider.autoDispose<IntervalNotifier, String>(
        (ref) => IntervalNotifier('1m'));



class IntervalNotifier extends StateNotifier<String> {
  IntervalNotifier(super.state);

  void updateIntetval(String val) {
    state = val;
  }
}


final intervals = [
    '1m',
    '3m',
    '5m',
    '15m',
    '30m',
    '1h',
    '2h',
    '4h',
    '6h',
    '8h',
    '12h',
    '1d',
    '3d',
    '1w',
    '1M',
  ];