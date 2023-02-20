import 'package:valstore/models/firebase_skin.dart';

class NightMarket {
  int? durationRemain;
  List<NightMarketSkin?>? skins;

  NightMarket({required this.durationRemain, required this.skins});
}

class NightMarketSkin {
  FirebaseSkin? skinData;
  int? percentageReduced;
  int? reducedCost;

  NightMarketSkin({
    required this.skinData,
    required this.percentageReduced,
  }) {
    if (skinData?.cost != null && percentageReduced != null) {
      reducedCost = (skinData!.cost! * percentageReduced! / 100).round();
    } else {
      reducedCost = 0;
    }
  }
}
