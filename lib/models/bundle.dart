class Bundle {
  int? status;
  List<Data>? data;

  Bundle({this.status, this.data});

  Bundle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
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
        items!.add(Items.fromJson(v));
      });
    }
    secondsRemaining = json['seconds_remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bundle_uuid'] = bundleUuid;
    data['bundle_price'] = bundlePrice;
    data['whole_sale_only'] = wholeSaleOnly;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['seconds_remaining'] = secondsRemaining;
    return data;
  }
}

class Items {
  String? uuid;
  String? name;
  String? image;
  String? type;
  int? amount;
  double? discountPercent;
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
    discountPercent = json['discount_percent'].toDouble();
    basePrice = json['base_price'];
    discountedPrice = json['discounted_price'];
    promoItem = json['promo_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['name'] = name;
    data['image'] = image;
    data['type'] = type;
    data['amount'] = amount;
    data['discount_percent'] = discountPercent;
    data['base_price'] = basePrice;
    data['discounted_price'] = discountedPrice;
    data['promo_item'] = promoItem;
    return data;
  }
}
