class Inventory {
  String? itemTypeID;
  List<Entitlements>? entitlements;

  Inventory({this.itemTypeID, this.entitlements});

  Inventory.fromJson(Map<String, dynamic> json) {
    itemTypeID = json['ItemTypeID'];
    if (json['Entitlements'] != null) {
      entitlements = <Entitlements>[];
      json['Entitlements'].forEach((v) {
        entitlements!.add(Entitlements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemTypeID'] = itemTypeID;
    if (entitlements != null) {
      data['Entitlements'] = entitlements!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TypeID'] = typeID;
    data['ItemID'] = itemID;
    return data;
  }
}
