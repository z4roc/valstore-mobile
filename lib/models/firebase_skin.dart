import 'package:valstore/models/val_api_skins.dart';

class PlayerShop {
  int? storeRemaining;
  List<FirebaseSkin> skins;
  DateTime lastUpdated;

  PlayerShop(
      {required this.storeRemaining,
      required this.skins,
      required this.lastUpdated});
}

class FirebaseSkin {
  String? name;
  String? offerId;
  String? skinId;
  List<Chromas>? chromas;
  List<Levels>? levels;
  int? cost;
  String? icon;
  ContentTier? contentTier;

  FirebaseSkin(
      {this.name,
      this.offerId,
      this.skinId,
      this.cost,
      this.icon,
      this.contentTier,
      this.chromas,
      this.levels});

  FirebaseSkin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    offerId = json['offer_id'];
    skinId = json['skin_id'];
    cost = json['cost'];
    icon = json['icon'];
    contentTier = json['content_tier'] != null
        ? ContentTier.fromJson(json['content_tier'])
        : null;
    if (json['chromas'] != null) {
      chromas = <Chromas>[];
      json['chromas'].forEach((c) {
        chromas!.add(Chromas.fromJson(c));
      });
    }
    if (json['levels'] != null) {
      levels = <Levels>[];
      json['levels'].forEach((c) {
        levels!.add(Levels.fromJson(c));
      });
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'offer_id': offerId,
        'skin_id': skinId,
        'levels': levels?.map((e) => e.toJson()),
        'chromas': chromas?.map((e) => e.toJson()),
        'content_tier': contentTier?.toJson(),
        'cost': cost,
        'icon': icon,
      };
}

class ContentTier {
  String? name;
  String? color;
  String? icon;

  ContentTier({this.name, this.color, this.icon});

  ContentTier.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color,
        'icon': icon,
      };
}

class Chroma {
  String? assetPath;
  String? displayIcon;
  String? displayName;
  String? fullRender;
  String? streamedVideo;
  String? swatch;
  String? uuid;

  Chroma(
      {this.assetPath,
      this.displayIcon,
      this.displayName,
      this.fullRender,
      this.streamedVideo,
      this.swatch,
      this.uuid});

  Chroma.fromJson(Map<String, dynamic> json) {
    assetPath = json['assetPath'];
    displayIcon = json['displayIcon'];
    displayName = json['displayName'];
    fullRender = json['fullRender'];
    streamedVideo = json['streamedVideo'];
    swatch = json['swatch'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() => {
        'assetPath': assetPath,
        'displayIcon': displayIcon,
        'displayName': displayName,
        'fullRender': fullRender,
        'streamedVideo': streamedVideo,
        'swatch': swatch,
        'uuid': uuid,
      };
}

class Level {
  String? assetPath;
  String? displayIcon;
  String? displayName;
  String? levelItem;
  String? streamedVideo;
  String? swatch;
  String? uuid;

  Level(
      {this.assetPath,
      this.displayIcon,
      this.displayName,
      this.levelItem,
      this.streamedVideo,
      this.swatch,
      this.uuid});

  Level.fromJson(Map<String, dynamic> json) {
    assetPath = json['assetPath'];
    displayIcon = json['displayIcon'];
    displayName = json['displayName'];
    levelItem = json['levelItem'];
    streamedVideo = json['streamedVideo'];
    swatch = json['swatch'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() => {
        'assetPath': assetPath,
        'displayIcon': displayIcon,
        'displayName': displayName,
        'streamedVideo': streamedVideo,
        'swatch': swatch,
        'uuid': uuid,
      };
}
