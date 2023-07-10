class LocalOffers {
  List<Offers>? offers;
  List<UpgradeCurrencyOffers>? upgradeCurrencyOffers;

  LocalOffers({this.offers, this.upgradeCurrencyOffers});

  LocalOffers.fromJson(Map<String, dynamic> json) {
    if (json['Offers'] != null) {
      offers = <Offers>[];
      json['Offers'].forEach((v) {
        offers!.add(new Offers.fromJson(v));
      });
    }
    if (json['UpgradeCurrencyOffers'] != null) {
      upgradeCurrencyOffers = <UpgradeCurrencyOffers>[];
      json['UpgradeCurrencyOffers'].forEach((v) {
        upgradeCurrencyOffers!.add(new UpgradeCurrencyOffers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.offers != null) {
      data['Offers'] = this.offers!.map((v) => v.toJson()).toList();
    }
    if (this.upgradeCurrencyOffers != null) {
      data['UpgradeCurrencyOffers'] =
          this.upgradeCurrencyOffers!.map((v) => v.toJson()).toList();
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
    offer = json['Offer'] != null ? new Offers.fromJson(json['Offer']) : null;
    discountedPercent = json['DiscountedPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OfferID'] = this.offerID;
    data['StorefrontItemID'] = this.storefrontItemID;
    if (this.offer != null) {
      data['Offer'] = this.offer!.toJson();
    }
    data['DiscountedPercent'] = this.discountedPercent;
    return data;
  }
}
