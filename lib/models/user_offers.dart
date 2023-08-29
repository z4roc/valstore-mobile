import 'package:valstore/models/store_models.dart';

class UserOffers {
  FeaturedBundle? featuredBundle;
  SkinsPanelLayout? skinsPanelLayout;
  UpgradeCurrencyStore? upgradeCurrencyStore;
  AccessoryStore? accessoryStore;

  UserOffers(
      {this.featuredBundle,
      this.skinsPanelLayout,
      this.upgradeCurrencyStore,
      this.accessoryStore});

  UserOffers.fromJson(Map<String, dynamic> json) {
    featuredBundle = json['FeaturedBundle'] != null
        ? FeaturedBundle.fromJson(json['FeaturedBundle'])
        : null;
    skinsPanelLayout = json['SkinsPanelLayout'] != null
        ? SkinsPanelLayout.fromJson(json['SkinsPanelLayout'])
        : null;
    upgradeCurrencyStore = json['UpgradeCurrencyStore'] != null
        ? UpgradeCurrencyStore.fromJson(json['UpgradeCurrencyStore'])
        : null;
    accessoryStore = json['AccessoryStore'] != null
        ? AccessoryStore.fromJson(json['AccessoryStore'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (featuredBundle != null) {
      data['FeaturedBundle'] = featuredBundle!.toJson();
    }
    if (skinsPanelLayout != null) {
      data['SkinsPanelLayout'] = skinsPanelLayout!.toJson();
    }
    if (upgradeCurrencyStore != null) {
      data['UpgradeCurrencyStore'] = upgradeCurrencyStore!.toJson();
    }
    if (accessoryStore != null) {
      data['AccessoryStore'] = accessoryStore!.toJson();
    }
    return data;
  }
}

class FeaturedBundle {
  Bundle? bundle;
  List<Bundles>? bundles;
  int? bundleRemainingDurationInSeconds;

  FeaturedBundle(
      {this.bundle, this.bundles, this.bundleRemainingDurationInSeconds});

  FeaturedBundle.fromJson(Map<String, dynamic> json) {
    bundle = json['Bundle'] != null ? Bundle.fromJson(json['Bundle']) : null;
    if (json['Bundles'] != null) {
      bundles = <Bundles>[];
      json['Bundles'].forEach((v) {
        bundles!.add(Bundles.fromJson(v));
      });
    }
    bundleRemainingDurationInSeconds = json['BundleRemainingDurationInSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bundle != null) {
      data['Bundle'] = bundle!.toJson();
    }
    if (bundles != null) {
      data['Bundles'] = bundles!.map((v) => v.toJson()).toList();
    }
    data['BundleRemainingDurationInSeconds'] = bundleRemainingDurationInSeconds;
    return data;
  }
}

class Bundle {
  String? iD;
  String? dataAssetID;
  String? currencyID;
  List<Items>? items;
  Null itemOffers;
  Null totalBaseCost;
  Null totalDiscountedCost;
  int? totalDiscountPercent;
  int? durationRemainingInSeconds;
  bool? wholesaleOnly;

  Bundle(
      {this.iD,
      this.dataAssetID,
      this.currencyID,
      this.items,
      this.itemOffers,
      this.totalBaseCost,
      this.totalDiscountedCost,
      this.totalDiscountPercent,
      this.durationRemainingInSeconds,
      this.wholesaleOnly});

  Bundle.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    dataAssetID = json['DataAssetID'];
    currencyID = json['CurrencyID'];
    if (json['Items'] != null) {
      items = <Items>[];
      json['Items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    itemOffers = json['ItemOffers'];
    totalBaseCost = json['TotalBaseCost'];
    totalDiscountedCost = json['TotalDiscountedCost'];
    totalDiscountPercent = json['TotalDiscountPercent'];
    durationRemainingInSeconds = json['DurationRemainingInSeconds'];
    wholesaleOnly = json['WholesaleOnly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['DataAssetID'] = dataAssetID;
    data['CurrencyID'] = currencyID;
    if (items != null) {
      data['Items'] = items!.map((v) => v.toJson()).toList();
    }
    data['ItemOffers'] = itemOffers;
    data['TotalBaseCost'] = totalBaseCost;
    data['TotalDiscountedCost'] = totalDiscountedCost;
    data['TotalDiscountPercent'] = totalDiscountPercent;
    data['DurationRemainingInSeconds'] = durationRemainingInSeconds;
    data['WholesaleOnly'] = wholesaleOnly;
    return data;
  }
}

class Items {
  Item? item;
  int? basePrice;
  String? currencyID;
  double? discountPercent;
  int? discountedPrice;
  bool? isPromoItem;

  Items(
      {this.item,
      this.basePrice,
      this.currencyID,
      this.discountPercent,
      this.discountedPrice,
      this.isPromoItem});

  Items.fromJson(Map<String, dynamic> json) {
    item = json['Item'] != null ? Item.fromJson(json['Item']) : null;
    basePrice = json['BasePrice'];
    currencyID = json['CurrencyID'];
    discountPercent = double.tryParse("${json['DiscountPercent']}");
    discountedPrice = json['DiscountedPrice'];
    isPromoItem = json['IsPromoItem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (item != null) {
      data['Item'] = item!.toJson();
    }
    data['BasePrice'] = basePrice;
    data['CurrencyID'] = currencyID;
    data['DiscountPercent'] = discountPercent;
    data['DiscountedPrice'] = discountedPrice;
    data['IsPromoItem'] = isPromoItem;
    return data;
  }
}

class Item {
  String? itemTypeID;
  String? itemID;
  int? amount;

  Item({this.itemTypeID, this.itemID, this.amount});

  Item.fromJson(Map<String, dynamic> json) {
    itemTypeID = json['ItemTypeID'];
    itemID = json['ItemID'];
    amount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemTypeID'] = itemTypeID;
    data['ItemID'] = itemID;
    data['Amount'] = amount;
    return data;
  }
}

class Bundles {
  String? iD;
  String? dataAssetID;
  String? currencyID;
  List<Items>? items;
  List<ItemOffers>? itemOffers;
  Cost? totalBaseCost;
  Cost? totalDiscountedCost;
  double? totalDiscountPercent;
  int? durationRemainingInSeconds;
  bool? wholesaleOnly;

  Bundles(
      {this.iD,
      this.dataAssetID,
      this.currencyID,
      this.items,
      this.itemOffers,
      this.totalBaseCost,
      this.totalDiscountedCost,
      this.totalDiscountPercent,
      this.durationRemainingInSeconds,
      this.wholesaleOnly});

  Bundles.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    dataAssetID = json['DataAssetID'];
    currencyID = json['CurrencyID'];
    if (json['Items'] != null) {
      items = <Items>[];
      json['Items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    if (json['ItemOffers'] != null) {
      itemOffers = <ItemOffers>[];
      json['ItemOffers'].forEach((v) {
        itemOffers!.add(ItemOffers.fromJson(v));
      });
    }
    totalBaseCost = json['TotalBaseCost'] != null
        ? Cost.fromJson(json['TotalBaseCost'])
        : null;
    totalDiscountedCost = json['TotalDiscountedCost'] != null
        ? Cost.fromJson(json['TotalDiscountedCost'])
        : null;
    totalDiscountPercent = json['TotalDiscountPercent'];
    durationRemainingInSeconds = json['DurationRemainingInSeconds'];
    wholesaleOnly = json['WholesaleOnly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['DataAssetID'] = dataAssetID;
    data['CurrencyID'] = currencyID;
    if (items != null) {
      data['Items'] = items!.map((v) => v.toJson()).toList();
    }
    if (itemOffers != null) {
      data['ItemOffers'] = itemOffers!.map((v) => v.toJson()).toList();
    }
    if (totalBaseCost != null) {
      data['TotalBaseCost'] = totalBaseCost!.toJson();
    }
    if (totalDiscountedCost != null) {
      data['TotalDiscountedCost'] = totalDiscountedCost!.toJson();
    }
    data['TotalDiscountPercent'] = totalDiscountPercent;
    data['DurationRemainingInSeconds'] = durationRemainingInSeconds;
    data['WholesaleOnly'] = wholesaleOnly;
    return data;
  }
}

class ItemOffers {
  String? bundleItemOfferID;
  Offer? offer;
  double? discountPercent;
  Cost? discountedCost;

  ItemOffers(
      {this.bundleItemOfferID,
      this.offer,
      this.discountPercent,
      this.discountedCost});

  ItemOffers.fromJson(Map<String, dynamic> json) {
    bundleItemOfferID = json['BundleItemOfferID'];
    offer = json['Offer'] != null ? Offer.fromJson(json['Offer']) : null;
    discountPercent = double.tryParse("${json['DiscountPercent']}");
    discountedCost = json['DiscountedCost'] != null
        ? Cost.fromJson(json['DiscountedCost'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BundleItemOfferID'] = bundleItemOfferID;
    if (offer != null) {
      data['Offer'] = offer!.toJson();
    }
    data['DiscountPercent'] = discountPercent;
    if (discountedCost != null) {
      data['DiscountedCost'] = discountedCost!.toJson();
    }
    return data;
  }
}

class Offer {
  String? offerID;
  bool? isDirectPurchase;
  String? startDate;
  Cost? cost;
  List<Rewards>? rewards;

  Offer(
      {this.offerID,
      this.isDirectPurchase,
      this.startDate,
      this.cost,
      this.rewards});

  Offer.fromJson(Map<String, dynamic> json) {
    offerID = json['OfferID'];
    isDirectPurchase = json['IsDirectPurchase'];
    startDate = json['StartDate'];
    cost = json['Cost'] != null ? Cost.fromJson(json['Cost']) : null;
    if (json['Rewards'] != null) {
      rewards = <Rewards>[];
      json['Rewards'].forEach((v) {
        rewards!.add(Rewards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OfferID'] = offerID;
    data['IsDirectPurchase'] = isDirectPurchase;
    data['StartDate'] = startDate;
    if (cost != null) {
      data['Cost'] = cost!.toJson();
    }
    if (rewards != null) {
      data['Rewards'] = rewards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cost {
  int? i85ad13f73d1b51289eb27cd8ee0b5741;

  Cost({this.i85ad13f73d1b51289eb27cd8ee0b5741});

  Cost.fromJson(Map<String, dynamic> json) {
    i85ad13f73d1b51289eb27cd8ee0b5741 =
        json['85ca954a-41f2-ce94-9b45-8ca3dd39a00d'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741'] =
        i85ad13f73d1b51289eb27cd8ee0b5741;
    return data;
  }
}

class Rewards {
  String? itemTypeID;
  String? itemID;
  int? quantity;

  Rewards({this.itemTypeID, this.itemID, this.quantity});

  Rewards.fromJson(Map<String, dynamic> json) {
    itemTypeID = json['ItemTypeID'];
    itemID = json['ItemID'];
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemTypeID'] = itemTypeID;
    data['ItemID'] = itemID;
    data['Quantity'] = quantity;
    return data;
  }
}

class SkinsPanelLayout {
  List<String>? singleItemOffers;
  List<SingleItemStoreOffers>? singleItemStoreOffers;
  int? singleItemOffersRemainingDurationInSeconds;

  SkinsPanelLayout(
      {this.singleItemOffers,
      this.singleItemStoreOffers,
      this.singleItemOffersRemainingDurationInSeconds});

  SkinsPanelLayout.fromJson(Map<String, dynamic> json) {
    singleItemOffers = json['SingleItemOffers'].cast<String>();
    if (json['SingleItemStoreOffers'] != null) {
      singleItemStoreOffers = <SingleItemStoreOffers>[];
      json['SingleItemStoreOffers'].forEach((v) {
        singleItemStoreOffers!.add(SingleItemStoreOffers.fromJson(v));
      });
    }
    singleItemOffersRemainingDurationInSeconds =
        json['SingleItemOffersRemainingDurationInSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SingleItemOffers'] = singleItemOffers;
    if (singleItemStoreOffers != null) {
      data['SingleItemStoreOffers'] =
          singleItemStoreOffers!.map((v) => v.toJson()).toList();
    }
    data['SingleItemOffersRemainingDurationInSeconds'] =
        singleItemOffersRemainingDurationInSeconds;
    return data;
  }
}

class UpgradeCurrencyStore {
  List<UpgradeCurrencyOffers>? upgradeCurrencyOffers;

  UpgradeCurrencyStore({this.upgradeCurrencyOffers});

  UpgradeCurrencyStore.fromJson(Map<String, dynamic> json) {
    if (json['UpgradeCurrencyOffers'] != null) {
      upgradeCurrencyOffers = <UpgradeCurrencyOffers>[];
      json['UpgradeCurrencyOffers'].forEach((v) {
        upgradeCurrencyOffers!.add(UpgradeCurrencyOffers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (upgradeCurrencyOffers != null) {
      data['UpgradeCurrencyOffers'] =
          upgradeCurrencyOffers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpgradeCurrencyOffers {
  String? offerID;
  String? storefrontItemID;
  Offer? offer;
  double? discountedPercent;

  UpgradeCurrencyOffers(
      {this.offerID,
      this.storefrontItemID,
      this.offer,
      this.discountedPercent});

  UpgradeCurrencyOffers.fromJson(Map<String, dynamic> json) {
    offerID = json['OfferID'];
    storefrontItemID = json['StorefrontItemID'];
    offer = json['Offer'] != null ? Offer.fromJson(json['Offer']) : null;
    discountedPercent = json['DiscountedPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OfferID'] = offerID;
    data['StorefrontItemID'] = storefrontItemID;
    if (offer != null) {
      data['Offer'] = offer!.toJson();
    }
    data['DiscountedPercent'] = discountedPercent;
    return data;
  }
}

class AccessoryStore {
  List<AccessoryStoreOffers>? accessoryStoreOffers;
  int? accessoryStoreRemainingDurationInSeconds;
  String? storefrontID;

  AccessoryStore(
      {this.accessoryStoreOffers,
      this.accessoryStoreRemainingDurationInSeconds,
      this.storefrontID});

  AccessoryStore.fromJson(Map<String, dynamic> json) {
    if (json['AccessoryStoreOffers'] != null) {
      accessoryStoreOffers = <AccessoryStoreOffers>[];
      json['AccessoryStoreOffers'].forEach((v) {
        accessoryStoreOffers!.add(AccessoryStoreOffers.fromJson(v));
      });
    }
    accessoryStoreRemainingDurationInSeconds =
        json['AccessoryStoreRemainingDurationInSeconds'];
    storefrontID = json['StorefrontID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (accessoryStoreOffers != null) {
      data['AccessoryStoreOffers'] =
          accessoryStoreOffers!.map((v) => v.toJson()).toList();
    }
    data['AccessoryStoreRemainingDurationInSeconds'] =
        accessoryStoreRemainingDurationInSeconds;
    data['StorefrontID'] = storefrontID;
    return data;
  }
}

class AccessoryStoreOffers {
  Offer? offer;
  String? contractID;

  AccessoryStoreOffers({this.offer, this.contractID});

  AccessoryStoreOffers.fromJson(Map<String, dynamic> json) {
    offer = json['Offer'] != null ? Offer.fromJson(json['Offer']) : null;
    contractID = json['ContractID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (offer != null) {
      data['Offer'] = offer!.toJson();
    }
    data['ContractID'] = contractID;
    return data;
  }
}
