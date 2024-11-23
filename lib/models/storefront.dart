class Storefront {
  final FeaturedBundle? featuredBundle;
  final SkinsPanelLayout? skinsPanelLayout;
  final UpgradeCurrencyStore? upgradeCurrencyStore;
  final AccessoryStore? accessoryStore;

  Storefront({
    this.featuredBundle,
    this.skinsPanelLayout,
    this.upgradeCurrencyStore,
    this.accessoryStore,
  });

  factory Storefront.fromJson(Map<String, dynamic> json) {
    return Storefront(
      featuredBundle: FeaturedBundle.fromJson(json['FeaturedBundle']),
      skinsPanelLayout: SkinsPanelLayout.fromJson(json['SkinsPanelLayout']),
      upgradeCurrencyStore:
          UpgradeCurrencyStore.fromJson(json['UpgradeCurrencyStore']),
      accessoryStore: AccessoryStore.fromJson(json['AccessoryStore']),
    );
  }
}

class FeaturedBundle {
  final Bundle? bundle;
  final List<Bundle>? bundles;
  final int? bundleRemainingDurationInSeconds;

  FeaturedBundle({
    this.bundle,
    this.bundles,
    this.bundleRemainingDurationInSeconds,
  });

  factory FeaturedBundle.fromJson(Map<String, dynamic> json) {
    return FeaturedBundle(
      bundle: Bundle.fromJson(json['Bundle']),
      bundles:
          (json['Bundles'] as List).map((i) => Bundle.fromJson(i)).toList(),
      bundleRemainingDurationInSeconds:
          json['BundleRemainingDurationInSeconds'],
    );
  }
}

class Bundle {
  final String? id;
  final String? dataAssetID;
  final String? currencyID;
  List<Item>? items;
  List<ItemOffer>? itemOffers;
  final Map<String, int>? totalBaseCost;
  final Map<String, int>? totalDiscountedCost;
  final num? totalDiscountPercent;
  final int? durationRemainingInSeconds;
  final bool? wholesaleOnly;
  final int? isGiftable;

  Bundle({
    required this.id,
    required this.dataAssetID,
    required this.currencyID,
    required this.items,
    required this.itemOffers,
    required this.totalBaseCost,
    required this.totalDiscountedCost,
    required this.totalDiscountPercent,
    required this.durationRemainingInSeconds,
    required this.wholesaleOnly,
    required this.isGiftable,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) {
    return Bundle(
      id: json['ID'],
      dataAssetID: json['DataAssetID'],
      currencyID: json['CurrencyID'],
      items: (json['Items'] as List).map((i) => Item.fromJson(i)).toList(),
      itemOffers: (json['ItemOffers'] as List)
          .map((i) => ItemOffer.fromJson(i))
          .toList(),
      totalBaseCost: Map<String, int>.from(json['TotalBaseCost']),
      totalDiscountedCost: Map<String, int>.from(json['TotalDiscountedCost']),
      totalDiscountPercent: json['TotalDiscountPercent'],
      durationRemainingInSeconds: json['DurationRemainingInSeconds'],
      wholesaleOnly: json['WholesaleOnly'],
      isGiftable: json['IsGiftable'],
    );
  }
}

class Item {
  final ItemDetails item;
  final int basePrice;
  final String currencyID;
  final num discountPercent;
  final int discountedPrice;
  final bool isPromoItem;

  Item({
    required this.item,
    required this.basePrice,
    required this.currencyID,
    required this.discountPercent,
    required this.discountedPrice,
    required this.isPromoItem,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      item: ItemDetails.fromJson(json['Item']),
      basePrice: json['BasePrice'],
      currencyID: json['CurrencyID'],
      discountPercent: json['DiscountPercent'],
      discountedPrice: json['DiscountedPrice'],
      isPromoItem: json['IsPromoItem'],
    );
  }
}

class ItemDetails {
  final String itemTypeID;
  final String itemID;
  final int amount;

  ItemDetails({
    required this.itemTypeID,
    required this.itemID,
    required this.amount,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      itemTypeID: json['ItemTypeID'],
      itemID: json['ItemID'],
      amount: json['Amount'],
    );
  }
}

class ItemOffer {
  final String bundleItemOfferID;
  final Offer offer;
  final num discountPercent;
  final Map<String, int> discountedCost;

  ItemOffer({
    required this.bundleItemOfferID,
    required this.offer,
    required this.discountPercent,
    required this.discountedCost,
  });

  factory ItemOffer.fromJson(Map<String, dynamic> json) {
    return ItemOffer(
      bundleItemOfferID: json['BundleItemOfferID'],
      offer: Offer.fromJson(json['Offer']),
      discountPercent: json['DiscountPercent'],
      discountedCost: Map<String, int>.from(json['DiscountedCost']),
    );
  }
}

class Offer {
  final String offerID;
  final bool isDirectPurchase;
  final String startDate;
  final Map<String, int> cost;
  final List<Reward> rewards;

  Offer({
    required this.offerID,
    required this.isDirectPurchase,
    required this.startDate,
    required this.cost,
    required this.rewards,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      offerID: json['OfferID'],
      isDirectPurchase: json['IsDirectPurchase'],
      startDate: json['StartDate'],
      cost: Map<String, int>.from(json['Cost']),
      rewards:
          (json['Rewards'] as List).map((i) => Reward.fromJson(i)).toList(),
    );
  }
}

class Reward {
  final String itemTypeID;
  final String itemID;
  final int quantity;

  Reward({
    required this.itemTypeID,
    required this.itemID,
    required this.quantity,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      itemTypeID: json['ItemTypeID'],
      itemID: json['ItemID'],
      quantity: json['Quantity'],
    );
  }
}

class SkinsPanelLayout {
  final List<String> singleItemOffers;
  final List<SingleItemStoreOffer> singleItemStoreOffers;
  final int singleItemOffersRemainingDurationInSeconds;

  SkinsPanelLayout({
    required this.singleItemOffers,
    required this.singleItemStoreOffers,
    required this.singleItemOffersRemainingDurationInSeconds,
  });

  factory SkinsPanelLayout.fromJson(Map<String, dynamic> json) {
    return SkinsPanelLayout(
      singleItemOffers: List<String>.from(json['SingleItemOffers']),
      singleItemStoreOffers: (json['SingleItemStoreOffers'] as List)
          .map((i) => SingleItemStoreOffer.fromJson(i))
          .toList(),
      singleItemOffersRemainingDurationInSeconds:
          json['SingleItemOffersRemainingDurationInSeconds'],
    );
  }
}

class SingleItemStoreOffer {
  final String offerID;
  final bool isDirectPurchase;
  final String startDate;
  final Map<String, int> cost;
  final List<Reward> rewards;

  SingleItemStoreOffer({
    required this.offerID,
    required this.isDirectPurchase,
    required this.startDate,
    required this.cost,
    required this.rewards,
  });

  factory SingleItemStoreOffer.fromJson(Map<String, dynamic> json) {
    return SingleItemStoreOffer(
      offerID: json['OfferID'],
      isDirectPurchase: json['IsDirectPurchase'],
      startDate: json['StartDate'],
      cost: Map<String, int>.from(json['Cost']),
      rewards:
          (json['Rewards'] as List).map((i) => Reward.fromJson(i)).toList(),
    );
  }
}

class UpgradeCurrencyStore {
  final List<UpgradeCurrencyOffer> upgradeCurrencyOffers;

  UpgradeCurrencyStore({
    required this.upgradeCurrencyOffers,
  });

  factory UpgradeCurrencyStore.fromJson(Map<String, dynamic> json) {
    return UpgradeCurrencyStore(
      upgradeCurrencyOffers: (json['UpgradeCurrencyOffers'] as List)
          .map((i) => UpgradeCurrencyOffer.fromJson(i))
          .toList(),
    );
  }
}

class UpgradeCurrencyOffer {
  final String offerID;
  final String storefrontItemID;
  final Offer offer;
  final num discountedPercent;

  UpgradeCurrencyOffer({
    required this.offerID,
    required this.storefrontItemID,
    required this.offer,
    required this.discountedPercent,
  });

  factory UpgradeCurrencyOffer.fromJson(Map<String, dynamic> json) {
    return UpgradeCurrencyOffer(
      offerID: json['OfferID'],
      storefrontItemID: json['StorefrontItemID'],
      offer: Offer.fromJson(json['Offer']),
      discountedPercent: json['DiscountedPercent'],
    );
  }
}

class AccessoryStore {
  final List<AccessoryStoreOffer> accessoryStoreOffers;
  final int accessoryStoreRemainingDurationInSeconds;
  final String storefrontID;

  AccessoryStore({
    required this.accessoryStoreOffers,
    required this.accessoryStoreRemainingDurationInSeconds,
    required this.storefrontID,
  });

  factory AccessoryStore.fromJson(Map<String, dynamic> json) {
    return AccessoryStore(
      accessoryStoreOffers: (json['AccessoryStoreOffers'] as List)
          .map((i) => AccessoryStoreOffer.fromJson(i))
          .toList(),
      accessoryStoreRemainingDurationInSeconds:
          json['AccessoryStoreRemainingDurationInSeconds'],
      storefrontID: json['StorefrontID'],
    );
  }
}

class AccessoryStoreOffer {
  final Offer offer;
  final String contractID;

  AccessoryStoreOffer({
    required this.offer,
    required this.contractID,
  });

  factory AccessoryStoreOffer.fromJson(Map<String, dynamic> json) {
    return AccessoryStoreOffer(
      offer: Offer.fromJson(json['Offer']),
      contractID: json['ContractID'],
    );
  }
}
