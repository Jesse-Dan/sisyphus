import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellTab extends ConsumerStatefulWidget {
  const SellTab({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyTabState();
}

class _BuyTabState extends ConsumerState<SellTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
