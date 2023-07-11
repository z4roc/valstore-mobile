class LocalOffers {
  List<Offers>? offers;
  List<UpgradeCurrencyOffers>? upgradeCurrencyOffers;

  LocalOffers({this.offers, this.upgradeCurrencyOffers});

  LocalOffers.fromJson(Map<String, dynamic> json) {
    if (json['Offers'] != null) {
      offers = <Offers>[];
      json['Offers'].forEach((v) {
        offers!.add(Offers.fromJson(v));
      });
    }
    if (json['UpgradeCurrencyOffers'] != null) {
      upgradeCurrencyOffers = <UpgradeCurrencyOffers>[];
      json['UpgradeCurrencyOffers'].forEach((v) {
        upgradeCurrencyOffers!.add(UpgradeCurrencyOffers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (offers != null) {
      data['Offers'] = offers!.map((v) => v.toJson()).toList();
    }
    if (upgradeCurrencyOffers != null) {
      data['UpgradeCurrencyOffers'] =
          upgradeCurrencyOffers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Offers {
  String? offerID;
  bool? isDirectPurchase;
  String? startDate;
  Cost? cost;
  List<Rewards>? rewards;

  Offers(
      {this.offerID,
      this.isDirectPurchase,
      this.startDate,
      this.cost,
      this.rewards});

  Offers.fromJson(Map<String, dynamic> json) {
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
        json['85ad13f7-3d1b-5128-9eb2-7cd8ee0b5741'];
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

class UpgradeCurrencyOffers {
  String? offerID;
  String? storefrontItemID;
  Offers? offer;
  double? discountedPercent;

  UpgradeCurrencyOffers(
      {this.offerID,
      this.storefrontItemID,
      this.offer,
      this.discountedPercent});

  UpgradeCurrencyOffers.fromJson(Map<String, dynamic> json) {
    offerID = json['OfferID'];
    storefrontItemID = json['StorefrontItemID'];
    offer = json['Offer'] != null ? Offers.fromJson(json['Offer']) : null;
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
