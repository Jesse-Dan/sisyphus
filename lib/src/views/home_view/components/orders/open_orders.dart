import 'package:flutter/material.dart';
import 'package:sisyphus/src/utils/components/app_card.dart';
import 'package:sisyphus/src/utils/dimentions.dart';
class OpenOrders extends StatelessWidget {
  const OpenOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: AppCard(
        addBorder: false,
        height: 350,
        child: _buildCardContent(context),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTitleText(context),
        const SizedBox(height: Dimentions.kSmallSpacing),
        _buildDescriptionText(context),
      ],
    );
  }

  Widget _buildTitleText(BuildContext context) {
    return Text(
      'No Open Orders',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: 1),
    );
  }

  Widget _buildDescriptionText(BuildContext context) {
    return Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Id pulvinar nullam sit imperdiet pulvinar.',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 15, fontWeight: FontWeight.w200, letterSpacing: 1),
      textAlign: TextAlign.center,
    );
  }
}
