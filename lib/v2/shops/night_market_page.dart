import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valstore/v2/valstore_provider.dart';
import 'package:valstore/views/night_market_page.dart';

class NightMarketPage extends StatefulWidget {
  const NightMarketPage({super.key});

  @override
  State<NightMarketPage> createState() => _NightMarketPageState();
}

class _NightMarketPageState extends State<NightMarketPage> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ValstoreProvider>(context);

    final nm = state.getInstance.nightMarket;

    if (nm != null) {
      return nightMarket(nm);
    } else {
      return noNightMarket();
    }
  }
}
