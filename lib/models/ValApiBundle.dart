class ValApiBundle {
  int? status;
  BundleData? data;

  ValApiBundle({this.status, this.data});

  ValApiBundle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new BundleData.fromJson(json['data']) : null;
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

class BundleData {
  String? uuid;
  String? displayName;
  Null? displayNameSubText;
  String? description;
  Null? extraDescription;
  Null? promoDescription;
  bool? useAdditionalContext;
  String? displayIcon;
  String? displayIcon2;
  String? verticalPromoImage;
  String? assetPath;

  BundleData(
      {this.uuid,
      this.displayName,
      this.displayNameSubText,
      this.description,
      this.extraDescription,
      this.promoDescription,
      this.useAdditionalContext,
      this.displayIcon,
      this.displayIcon2,
      this.verticalPromoImage,
      this.assetPath});

  BundleData.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    displayName = json['displayName'];
    displayNameSubText = json['displayNameSubText'];
    description = json['description'];
    extraDescription = json['extraDescription'];
    promoDescription = json['promoDescription'];
    useAdditionalContext = json['useAdditionalContext'];
    displayIcon = json['displayIcon'];
    displayIcon2 = json['displayIcon2'];
    verticalPromoImage = json['verticalPromoImage'];
    assetPath = json['assetPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['displayName'] = this.displayName;
    data['displayNameSubText'] = this.displayNameSubText;
    data['description'] = this.description;
    data['extraDescription'] = this.extraDescription;
    data['promoDescription'] = this.promoDescription;
    data['useAdditionalContext'] = this.useAdditionalContext;
    data['displayIcon'] = this.displayIcon;
    data['displayIcon2'] = this.displayIcon2;
    data['verticalPromoImage'] = this.verticalPromoImage;
    data['assetPath'] = this.assetPath;
    return data;
  }
}
