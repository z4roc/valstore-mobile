import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/val_api_bundle.dart';
import 'package:valstore/models/user_offers.dart' as uo;

class BundleDisplayData {
  uo.Bundles? data;
  List<FirebaseSkin>? skins;
  BundleData? bundleData;

  BundleDisplayData(
      {required this.bundleData, required this.data, required this.skins});
}
