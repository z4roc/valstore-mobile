import 'package:valstore/models/bundle_display_data.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/local_offers.dart';
import 'package:valstore/models/night_market_model.dart';
import 'package:valstore/models/player.dart';
import 'package:valstore/models/val_api_skins.dart';

class Valstore {
  PlayerShop? playerShop;
  Player? player;
  NightMarket? nightMarket;
  List<BundleDisplayData?>? bundles;
  List<Data?>? playerInventory;
  LocalOffers? localOffers;

  Valstore({
    this.playerShop,
    this.player,
    this.nightMarket,
    this.bundles,
    this.playerInventory,
    this.localOffers,
  });
}
