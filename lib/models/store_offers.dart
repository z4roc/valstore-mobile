class StoreOffers {
  int? status;
  Data? data;

  StoreOffers({this.status, this.data});

  StoreOffers.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Offers>? offers;

  Data({this.offers});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['offers'] != null) {
      offers = <Offers>[];
      json['offers'].forEach((v) {
        offers!.add(Offers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (offers != null) {
      data['offers'] = offers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Offers {
  String? offerId;
  int? cost;
  String? name;
  String? icon;
  String? type;
  String? skinId;
  ContentTier? contentTier;

  Offers(
      {this.offerId,
      this.cost,
      this.name,
      this.icon,
      this.type,
      this.skinId,
      this.contentTier});

  Offers.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    cost = json['cost'];
    name = json['name'];
    icon = json['icon'];
    type = json['type'];
    skinId = json['skin_id'];
    contentTier = json['content_tier'] != null
        ? ContentTier.fromJson(json['content_tier'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offer_id'] = offerId;
    data['cost'] = cost;
    data['name'] = name;
    data['icon'] = icon;
    data['type'] = type;
    data['skin_id'] = skinId;
    if (contentTier != null) {
      data['content_tier'] = contentTier!.toJson();
    }
    return data;
  }
}

class ContentTier {
  String? name;
  String? devName;
  String? icon;

  ContentTier({this.name, this.devName, this.icon});

  ContentTier.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    devName = json['dev_name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dev_name'] = devName;
    data['icon'] = icon;
    return data;
  }
}
