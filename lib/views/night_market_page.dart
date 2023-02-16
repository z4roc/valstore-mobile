import 'package:flutter/material.dart';
import 'package:valstore/flyout_nav.dart';
import 'package:valstore/models/night_market_model.dart';
import 'package:valstore/models/store_models.dart';
import 'package:valstore/services/riot_service.dart';

final color = const Color(0xFF16141a).withOpacity(.8);

class NightMarketPage extends StatefulWidget {
  const NightMarketPage({super.key});

  @override
  State<NightMarketPage> createState() => _NightMarketPageState();
}

class _NightMarketPageState extends State<NightMarketPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RiotService().getNightMarket(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading();
        } else if (!snapshot.hasData) {
          return noNightMarket();
        } else if (snapshot.hasData) {
          return nightMarket(snapshot.data!);
        }
        return errorLoading();
      },
    );
  }
}

Widget loading() => Scaffold(
      appBar: AppBar(
        title: const Text("Night Market"),
      ),
      backgroundColor: color,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(1),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

Widget noNightMarket() => Scaffold(
      appBar: AppBar(
        title: const Text("Night Market"),
      ),
      backgroundColor: color,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(1),
        child: const Center(
          child: Text("There is currently no Night Market"),
        ),
      ),
    );

Widget errorLoading() => Scaffold(
      appBar: AppBar(
        title: const Text("Night Market"),
      ),
      backgroundColor: color,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(1),
        child: const Center(
          child: Text("Error retrieving Data"),
        ),
      ),
    );

Widget nightMarket(NightMarket store) => Scaffold(
      appBar: AppBar(
        title: const Text("Night Market"),
      ),
    );
