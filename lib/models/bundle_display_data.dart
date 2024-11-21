import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/val_api_bundle.dart';
import 'package:valstore/models/storefront.dart' as sf;

class BundleDisplayData {
  sf.Bundle? data;
  List<FirebaseSkin>? skins;
  BundleData? bundleData;

  BundleDisplayData(
      {required this.bundleData, required this.data, required this.skins});
}
