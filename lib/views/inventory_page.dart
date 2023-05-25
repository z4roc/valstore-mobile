import 'package:flutter/material.dart';
import 'package:valstore/flyout_nav.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/views/galery_page.dart';
import 'package:valstore/views/night_market_page.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("Inventory"),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final skin = snapshot.data![index];

                if (skin == null) return const SizedBox();

                return itemTile(skin);
              },
            );
          } else {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading Inventory..."),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
        future: RiotService().getUserOwnedItems(),
      ),
    );
  }
}
