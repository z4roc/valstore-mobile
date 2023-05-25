class Inventory {
  String? itemTypeID;
  List<Entitlements>? entitlements;

  Inventory({this.itemTypeID, this.entitlements});

  Inventory.fromJson(Map<String, dynamic> json) {
    itemTypeID = json['ItemTypeID'];
    if (json['Entitlements'] != null) {
      entitlements = <Entitlements>[];
      json['Entitlements'].forEach((v) {
        entitlements!.add(new Entitlements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemTypeID'] = this.itemTypeID;
    if (this.entitlements != null) {
      data['Entitlements'] = this.entitlements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entitlements {
  String? typeID;
  String? itemID;

  Entitlements({this.typeID, this.itemID});

  Entitlements.fromJson(Map<String, dynamic> json) {
    typeID = json['TypeID'];
    itemID = json['ItemID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TypeID'] = this.typeID;
    data['ItemID'] = this.itemID;
    return data;
  }
}
