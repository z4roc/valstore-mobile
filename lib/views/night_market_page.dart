import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:valstore/flyout_nav.dart';

class NightMarketPage extends StatefulWidget {
  const NightMarketPage({super.key});

  @override
  State<NightMarketPage> createState() => _NightMarketPageState();
}

class _NightMarketPageState extends State<NightMarketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Night Market'),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.nightlight_round_rounded),
              SizedBox(
                height: 10,
              ),
              Text('There is currently no Night Market!'),
            ],
          ),
        ),
      ),
    );
  }
}
