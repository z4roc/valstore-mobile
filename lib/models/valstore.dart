import 'package:valstore/models/bundle_display_data.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/local_offers.dart';
import 'package:valstore/models/night_market_model.dart';
import 'package:valstore/models/player.dart';
import 'package:valstore/models/val_api_skins.dart';

class Valstore {
  final PlayerShop playerShop;
  final Player player;
  final NightMarket? nightMarket;
  final List<BundleDisplayData?> bundles;
  final List<Data?>? playerInventory;
  final LocalOffers localOffers;

  Valstore({
    required this.playerShop,
    required this.player,
    this.nightMarket,
    required this.bundles,
    required this.playerInventory,
    required this.localOffers,
  });
}
