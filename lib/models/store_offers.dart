class StoreOffers {
  int? status;
  Data? data;

  StoreOffers({this.status, this.data});

  StoreOffers.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
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
        offers!.add(new Offers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.offers != null) {
      data['offers'] = this.offers!.map((v) => v.toJson()).toList();
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
        ? new ContentTier.fromJson(json['content_tier'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_id'] = this.offerId;
    data['cost'] = this.cost;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['type'] = this.type;
    data['skin_id'] = this.skinId;
    if (this.contentTier != null) {
      data['content_tier'] = this.contentTier!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dev_name'] = this.devName;
    data['icon'] = this.icon;
    return data;
  }
}
