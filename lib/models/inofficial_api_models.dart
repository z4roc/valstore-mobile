abstract class DisplayableItem {
  String? uuid;
  String? displayName;
  String? displayIcon;
}

class PlayerTitles {
  int? status;
  List<PlayerTitle>? data;

  PlayerTitles({this.status, this.data});

  PlayerTitles.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PlayerTitle>[];
      json['data'].forEach((v) {
        data!.add(PlayerTitle.fromJson(v));
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

class PlayerTitle extends DisplayableItem {
  String? titleText;
  bool? isHiddenIfNotOwned;
  String? assetPath;

  PlayerTitle({this.titleText, this.isHiddenIfNotOwned, this.assetPath});

  PlayerTitle.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    displayName = json['displayName'];
    titleText = json['titleText'];
    isHiddenIfNotOwned = json['isHiddenIfNotOwned'];
    assetPath = json['assetPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['displayName'] = displayName;
    data['titleText'] = titleText;
    data['isHiddenIfNotOwned'] = isHiddenIfNotOwned;
    data['assetPath'] = assetPath;
    return data;
  }
}

class Gunbuddies {
  List<Gunbuddie>? sprays;

  Gunbuddies({this.sprays});

  Gunbuddies.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      sprays = <Gunbuddie>[];
      json['data'].forEach((v) {
        sprays!.add(Gunbuddie.fromJson(v));
      });
    }
  }
}

class Sprays {
  List<Spray>? sprays;

  Sprays({this.sprays});

  Sprays.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      sprays = <Spray>[];
      json['data'].forEach((v) {
        sprays!.add(Spray.fromJson(v));
      });
    }
  }
}

class Playercards {
  List<Playercard>? sprays;

  Playercards({this.sprays});

  Playercards.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      sprays = <Playercard>[];
      json['data'].forEach((v) {
        sprays!.add(Playercard.fromJson(v));
      });
    }
  }
}

class Spray extends DisplayableItem {
  String? category;
  String? themeUuid;
  bool? isNullSpray;
  String? fullIcon;
  String? fullTransparentIcon;
  String? animationPng;
  String? animationGif;
  String? assetPath;
  List<Levels>? levels;

  Spray(
      {this.category,
      this.themeUuid,
      this.isNullSpray,
      this.fullIcon,
      this.fullTransparentIcon,
      this.animationPng,
      this.animationGif,
      this.assetPath,
      this.levels});

  Spray.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    displayName = json['displayName'];
    category = json['category'];
    themeUuid = json['themeUuid'];
    isNullSpray = json['isNullSpray'];
    displayIcon = json['displayIcon'];
    fullIcon = json['fullIcon'];
    fullTransparentIcon = json['fullTransparentIcon'];
    animationPng = json['animationPng'];
    animationGif = json['animationGif'];
    assetPath = json['assetPath'];
    if (json['levels'] != null) {
      levels = <Levels>[];
      json['levels'].forEach((v) {
        levels!.add(Levels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['displayName'] = displayName;
    data['category'] = category;
    data['themeUuid'] = themeUuid;
    data['isNullSpray'] = isNullSpray;
    data['displayIcon'] = displayIcon;
    data['fullIcon'] = fullIcon;
    data['fullTransparentIcon'] = fullTransparentIcon;
    data['animationPng'] = animationPng;
    data['animationGif'] = animationGif;
    data['assetPath'] = assetPath;
    if (levels != null) {
      data['levels'] = levels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Levels {
  String? uuid;
  int? sprayLevel;
  String? displayName;
  String? displayIcon;
  String? assetPath;

  Levels(
      {this.uuid,
      this.sprayLevel,
      this.displayName,
      this.displayIcon,
      this.assetPath});

  Levels.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    sprayLevel = json['sprayLevel'];
    displayName = json['displayName'];
    displayIcon = json['displayIcon'];
    assetPath = json['assetPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['sprayLevel'] = sprayLevel;
    data['displayName'] = displayName;
    data['displayIcon'] = displayIcon;
    data['assetPath'] = assetPath;
    return data;
  }
}

class Playercard extends DisplayableItem {
  bool? isHiddenIfNotOwned;
  String? themeUuid;
  String? smallArt;
  String? wideArt;
  String? largeArt;
  String? assetPath;

  Playercard(
      {this.isHiddenIfNotOwned,
      this.themeUuid,
      this.smallArt,
      this.wideArt,
      this.largeArt,
      this.assetPath});

  Playercard.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    displayName = json['displayName'];
    isHiddenIfNotOwned = json['isHiddenIfNotOwned'];
    themeUuid = json['themeUuid'];
    displayIcon = json['displayIcon'];
    smallArt = json['smallArt'];
    wideArt = json['wideArt'];
    largeArt = json['largeArt'];
    assetPath = json['assetPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['displayName'] = displayName;
    data['isHiddenIfNotOwned'] = isHiddenIfNotOwned;
    data['themeUuid'] = themeUuid;
    data['displayIcon'] = displayIcon;
    data['smallArt'] = smallArt;
    data['wideArt'] = wideArt;
    data['largeArt'] = largeArt;
    data['assetPath'] = assetPath;
    return data;
  }
}

class Gunbuddie extends DisplayableItem {
  bool? isHiddenIfNotOwned;
  String? themeUuid;
  String? assetPath;
  List<BuddiesLevels>? levels;

  Gunbuddie(
      {this.isHiddenIfNotOwned, this.themeUuid, this.assetPath, this.levels});

  Gunbuddie.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    displayName = json['displayName'];
    isHiddenIfNotOwned = json['isHiddenIfNotOwned'];
    themeUuid = json['themeUuid'];
    displayIcon = json['displayIcon'];
    assetPath = json['assetPath'];
    if (json['levels'] != null) {
      levels = <BuddiesLevels>[];
      json['levels'].forEach((v) {
        levels!.add(BuddiesLevels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['displayName'] = displayName;
    data['isHiddenIfNotOwned'] = isHiddenIfNotOwned;
    data['themeUuid'] = themeUuid;
    data['displayIcon'] = displayIcon;
    data['assetPath'] = assetPath;
    if (levels != null) {
      data['levels'] = levels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BuddiesLevels {
  String? uuid;
  int? charmLevel;
  String? displayName;
  String? displayIcon;
  String? assetPath;

  BuddiesLevels(
      {this.uuid,
      this.charmLevel,
      this.displayName,
      this.displayIcon,
      this.assetPath});

  BuddiesLevels.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    charmLevel = json['charmLevel'];
    displayName = json['displayName'];
    displayIcon = json['displayIcon'];
    assetPath = json['assetPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['charmLevel'] = charmLevel;
    data['displayName'] = displayName;
    data['displayIcon'] = displayIcon;
    data['assetPath'] = assetPath;
    return data;
  }
}

class LevelBorders {
  List<LevelBorder>? borders;

  LevelBorders({this.borders});

  LevelBorders.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      borders = <LevelBorder>[];
      json['data'].forEach((v) {
        borders!.add(LevelBorder.fromJson(v));
      });
    }
  }
}

class LevelBorder {
  String? uuid;
  int? startingLevel;
  String? levelNumberAppearance;
  String? smallPlayerCardAppearance;
  String? assetPath;

  LevelBorder(
      {this.uuid,
      this.startingLevel,
      this.levelNumberAppearance,
      this.smallPlayerCardAppearance,
      this.assetPath});

  LevelBorder.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    startingLevel = json['startingLevel'];
    levelNumberAppearance = json['levelNumberAppearance'];
    smallPlayerCardAppearance = json['smallPlayerCardAppearance'];
    assetPath = json['assetPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['startingLevel'] = startingLevel;
    data['levelNumberAppearance'] = levelNumberAppearance;
    data['smallPlayerCardAppearance'] = smallPlayerCardAppearance;
    data['assetPath'] = assetPath;
    return data;
  }
}
