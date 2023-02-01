class Bundle {
  int? status;
  List<Data>? data;

  Bundle({this.status, this.data});

  Bundle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? bundleUuid;
  int? bundlePrice;
  bool? wholeSaleOnly;
  List<Items>? items;
  int? secondsRemaining;

  Data(
      {this.bundleUuid,
      this.bundlePrice,
      this.wholeSaleOnly,
      this.items,
      this.secondsRemaining});

  Data.fromJson(Map<String, dynamic> json) {
    bundleUuid = json['bundle_uuid'];
    bundlePrice = json['bundle_price'];
    wholeSaleOnly = json['whole_sale_only'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    secondsRemaining = json['seconds_remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bundle_uuid'] = this.bundleUuid;
    data['bundle_price'] = this.bundlePrice;
    data['whole_sale_only'] = this.wholeSaleOnly;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['seconds_remaining'] = this.secondsRemaining;
    return data;
  }
}

class Items {
  String? uuid;
  String? name;
  String? image;
  String? type;
  int? amount;
  int? discountPercent;
  int? basePrice;
  int? discountedPrice;
  bool? promoItem;

  Items(
      {this.uuid,
      this.name,
      this.image,
      this.type,
      this.amount,
      this.discountPercent,
      this.basePrice,
      this.discountedPrice,
      this.promoItem});

  Items.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
    amount = json['amount'];
    discountPercent = json['discount_percent'];
    basePrice = json['base_price'];
    discountedPrice = json['discounted_price'];
    promoItem = json['promo_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['image'] = this.image;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['discount_percent'] = this.discountPercent;
    data['base_price'] = this.basePrice;
    data['discounted_price'] = this.discountedPrice;
    data['promo_item'] = this.promoItem;
    return data;
  }
}
