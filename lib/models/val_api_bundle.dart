class ValApiBundle {
  int? status;
  BundleData? data;

  ValApiBundle({this.status, this.data});

  ValApiBundle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? BundleData.fromJson(json['data']) : null;
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

class BundleData {
  String? uuid;
  String? displayName;
  String? displayNameSubText;
  String? description;
  String? extraDescription;
  String? promoDescription;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['displayName'] = displayName;
    data['displayNameSubText'] = displayNameSubText;
    data['description'] = description;
    data['extraDescription'] = extraDescription;
    data['promoDescription'] = promoDescription;
    data['useAdditionalContext'] = useAdditionalContext;
    data['displayIcon'] = displayIcon;
    data['displayIcon2'] = displayIcon2;
    data['verticalPromoImage'] = verticalPromoImage;
    data['assetPath'] = assetPath;
    return data;
  }
}
