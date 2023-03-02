class Shop {
  FeaturedBundle? featuredBundle;
  SkinsPanelLayout? skinsPanelLayout;
  UpgradeCurrencyStore? upgradeCurrencyStore;
  BonusStore? bonusStore;

  Shop(
      {this.featuredBundle,
      this.skinsPanelLayout,
      this.upgradeCurrencyStore,
      this.bonusStore});

  Shop.fromJson(Map<String, dynamic> json) {
    featuredBundle = json['FeaturedBundle'] != null
        ? new FeaturedBundle.fromJson(json['FeaturedBundle'])
        : null;
    skinsPanelLayout = json['SkinsPanelLayout'] != null
        ? new SkinsPanelLayout.fromJson(json['SkinsPanelLayout'])
        : null;
    upgradeCurrencyStore = json['UpgradeCurrencyStore'] != null
        ? new UpgradeCurrencyStore.fromJson(json['UpgradeCurrencyStore'])
        : null;
    bonusStore = json['BonusStore'] != null
        ? new BonusStore.fromJson(json['BonusStore'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.featuredBundle != null) {
      data['FeaturedBundle'] = this.featuredBundle!.toJson();
    }
    if (this.skinsPanelLayout != null) {
      data['SkinsPanelLayout'] = this.skinsPanelLayout!.toJson();
    }
    if (this.upgradeCurrencyStore != null) {
      data['UpgradeCurrencyStore'] = this.upgradeCurrencyStore!.toJson();
    }
    if (this.bonusStore != null) {
      data['BonusStore'] = this.bonusStore!.toJson();
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
    bundle =
        json['Bundle'] != null ? new Bundle.fromJson(json['Bundle']) : null;
    if (json['Bundles'] != null) {
      bundles = <Bundles>[];
      json['Bundles'].forEach((v) {
        bundles!.add(new Bundles.fromJson(v));
      });
    }
    bundleRemainingDurationInSeconds = json['BundleRemainingDurationInSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bundle != null) {
      data['Bundle'] = this.bundle!.toJson();
    }
    if (this.bundles != null) {
      data['Bundles'] = this.bundles!.map((v) => v.toJson()).toList();
    }
    data['BundleRemainingDurationInSeconds'] =
        this.bundleRemainingDurationInSeconds;
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
    offer = json['Offer'] != null ? new Offer.fromJson(json['Offer']) : null;
    discountPercent = json['DiscountPercent'] != null
        ? double.parse("${json['DiscountPercent']}")
        : null;
    discountedCost = json['DiscountedCost'] != null
        ? new Cost.fromJson(json['DiscountedCost'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BundleItemOfferID'] = this.bundleItemOfferID;
    if (this.offer != null) {
      data['Offer'] = this.offer!.toJson();
    }
    data['DiscountPercent'] = this.discountPercent;
    if (this.discountedCost != null) {
      data['DiscountedCost'] = this.discountedCost!.toJson();
    }
    return data;
  }
}

class Bundle {
  String? iD;
  String? dataAssetID;
  String? currencyID;
  List<Items>? items;
  List<ItemOffers>? itemOffers;
  int? totalBaseCost;
  int? totalDiscountedCost;
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
        items!.add(new Items.fromJson(v));
      });
    }
    if (json['ItemOffers'] != null) {
      itemOffers = <ItemOffers>[];
      json['Items'].forEach((v) {
        itemOffers!.add(new ItemOffers.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['DataAssetID'] = this.dataAssetID;
    data['CurrencyID'] = this.currencyID;
    if (this.items != null) {
      data['Items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['ItemOffers'] = this.itemOffers;
    data['TotalBaseCost'] = this.totalBaseCost;
    data['TotalDiscountedCost'] = this.totalDiscountedCost;
    data['TotalDiscountPercent'] = this.totalDiscountPercent;
    data['DurationRemainingInSeconds'] = this.durationRemainingInSeconds;
    data['WholesaleOnly'] = this.wholesaleOnly;
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
    item = json['Item'] != null ? new Item.fromJson(json['Item']) : null;
    basePrice = json['BasePrice'];
    currencyID = json['CurrencyID'];
    discountPercent = json['DiscountPercent'] != null
        ? double.parse("${json['DiscountPercent']}")
        : null;
    discountedPrice = json['DiscountedPrice'];
    isPromoItem = json['IsPromoItem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['Item'] = this.item!.toJson();
    }
    data['BasePrice'] = this.basePrice;
    data['CurrencyID'] = this.currencyID;
    data['DiscountPercent'] = this.discountPercent;
    data['DiscountedPrice'] = this.discountedPrice;
    data['IsPromoItem'] = this.isPromoItem;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemTypeID'] = this.itemTypeID;
    data['ItemID'] = this.itemID;
    data['Amount'] = this.amount;
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
        items!.add(new Items.fromJson(v));
      });
    }
    if (json['ItemOffers'] != null) {
      itemOffers = <ItemOffers>[];
      json['ItemOffers'].forEach((v) {
        itemOffers!.add(new ItemOffers.fromJson(v));
      });
    }
    totalBaseCost = json['TotalBaseCost'] != null
        ? new Cost.fromJson(json['TotalBaseCost'])
        : null;
    totalDiscountedCost = json['TotalDiscountedCost'] != null
        ? new Cost.fromJson(json['TotalDiscountedCost'])
        : null;
    totalDiscountPercent = json['TotalDiscountPercent'];
    durationRemainingInSeconds = json['DurationRemainingInSeconds'];
    wholesaleOnly = json['WholesaleOnly'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['DataAssetID'] = this.dataAssetID;
    data['CurrencyID'] = this.currencyID;
    if (this.items != null) {
      data['Items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.itemOffers != null) {
      data['ItemOffers'] = this.itemOffers!.map((v) => v.toJson()).toList();
    }
    if (this.totalBaseCost != null) {
      data['TotalBaseCost'] = this.totalBaseCost!.toJson();
    }
    if (this.totalDiscountedCost != null) {
      data['TotalDiscountedCost'] = this.totalDiscountedCost!.toJson();
    }
    data['TotalDiscountPercent'] = this.totalDiscountPercent;
    data['DurationRemainingInSeconds'] = this.durationRemainingInSeconds;
    data['WholesaleOnly'] = this.wholesaleOnly;
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
    cost = json['Cost'] != null ? new Cost.fromJson(json['Cost']) : null;
    if (json['Rewards'] != null) {
      rewards = <Rewards>[];
      json['Rewards'].forEach((v) {
        rewards!.add(new Rewards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OfferID'] = this.offerID;
    data['IsDirectPurchase'] = this.isDirectPurchase;
    data['StartDate'] = this.startDate;
    if (this.cost != null) {
      data['Cost'] = this.cost!.toJson();
    }
    if (this.rewards != null) {
      data['Rewards'] = this.rewards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cost {
  int? i85ad13f73d1b51289eb27cd8ee0b5741;

  Cost({this.i85ad13f73d1b51289eb27cd8ee0b5741});

  Cost.fromJson(Map<String, dynamic> json) {
    i85ad13f73d1b51289eb27cd8ee0b5741 =
        json['85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741'] =
        this.i85ad13f73d1b51289eb27cd8ee0b5741;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemTypeID'] = this.itemTypeID;
    data['ItemID'] = this.itemID;
    data['Quantity'] = this.quantity;
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
        singleItemStoreOffers!.add(new SingleItemStoreOffers.fromJson(v));
      });
    }
    singleItemOffersRemainingDurationInSeconds =
        json['SingleItemOffersRemainingDurationInSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SingleItemOffers'] = this.singleItemOffers;
    if (this.singleItemStoreOffers != null) {
      data['SingleItemStoreOffers'] =
          this.singleItemStoreOffers!.map((v) => v.toJson()).toList();
    }
    data['SingleItemOffersRemainingDurationInSeconds'] =
        this.singleItemOffersRemainingDurationInSeconds;
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
        upgradeCurrencyOffers!.add(new UpgradeCurrencyOffers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upgradeCurrencyOffers != null) {
      data['UpgradeCurrencyOffers'] =
          this.upgradeCurrencyOffers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpgradeCurrencyOffers {
  String? offerID;
  String? storefrontItemID;
  Offer? offer;

  UpgradeCurrencyOffers({this.offerID, this.storefrontItemID, this.offer});

  UpgradeCurrencyOffers.fromJson(Map<String, dynamic> json) {
    offerID = json['OfferID'];
    storefrontItemID = json['StorefrontItemID'];
    offer = json['Offer'] != null ? new Offer.fromJson(json['Offer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OfferID'] = this.offerID;
    data['StorefrontItemID'] = this.storefrontItemID;
    if (this.offer != null) {
      data['Offer'] = this.offer!.toJson();
    }
    return data;
  }
}

class BonusStore {
  List<BonusStoreOffers>? bonusStoreOffers;
  int? bonusStoreRemainingDurationInSeconds;

  BonusStore(
      {this.bonusStoreOffers, this.bonusStoreRemainingDurationInSeconds});

  BonusStore.fromJson(Map<String, dynamic> json) {
    if (json['BonusStoreOffers'] != null) {
      bonusStoreOffers = <BonusStoreOffers>[];
      json['BonusStoreOffers'].forEach((v) {
        bonusStoreOffers!.add(new BonusStoreOffers.fromJson(v));
      });
    }
    bonusStoreRemainingDurationInSeconds =
        json['BonusStoreRemainingDurationInSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bonusStoreOffers != null) {
      data['BonusStoreOffers'] =
          this.bonusStoreOffers!.map((v) => v.toJson()).toList();
    }
    data['BonusStoreRemainingDurationInSeconds'] =
        this.bonusStoreRemainingDurationInSeconds;
    return data;
  }
}

class BonusStoreOffers {
  String? bonusOfferID;
  Offer? offer;
  int? discountPercent;
  Cost? discountCosts;
  bool? isSeen;

  BonusStoreOffers(
      {this.bonusOfferID,
      this.offer,
      this.discountPercent,
      this.discountCosts,
      this.isSeen});

  BonusStoreOffers.fromJson(Map<String, dynamic> json) {
    bonusOfferID = json['BonusOfferID'];
    offer = json['Offer'] != null ? new Offer.fromJson(json['Offer']) : null;
    discountPercent = json['DiscountPercent'];
    discountCosts = json['DiscountCosts'] != null
        ? new Cost.fromJson(json['DiscountCosts'])
        : null;
    isSeen = json['IsSeen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BonusOfferID'] = this.bonusOfferID;
    if (this.offer != null) {
      data['Offer'] = this.offer!.toJson();
    }
    data['DiscountPercent'] = this.discountPercent;
    if (this.discountCosts != null) {
      data['DiscountCosts'] = this.discountCosts!.toJson();
    }
    data['IsSeen'] = this.isSeen;
    return data;
  }
}

class SingleItemStoreOffers {
  String? offerID;
  bool? isDirectPurchase;
  String? startDate;
  Cost? cost;
  List<Rewards>? rewards;

  SingleItemStoreOffers(
      {this.offerID,
      this.isDirectPurchase,
      this.startDate,
      this.cost,
      this.rewards});

  SingleItemStoreOffers.fromJson(Map<String, dynamic> json) {
    offerID = json['OfferID'];
    isDirectPurchase = json['IsDirectPurchase'];
    startDate = json['StartDate'];
    cost = json['Cost'] != null ? new Cost.fromJson(json['Cost']) : null;
    if (json['Rewards'] != null) {
      rewards = <Rewards>[];
      json['Rewards'].forEach((v) {
        rewards!.add(new Rewards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OfferID'] = this.offerID;
    data['IsDirectPurchase'] = this.isDirectPurchase;
    data['StartDate'] = this.startDate;
    if (this.cost != null) {
      data['Cost'] = this.cost!.toJson();
    }
    if (this.rewards != null) {
      data['Rewards'] = this.rewards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
