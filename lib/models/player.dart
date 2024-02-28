import 'package:valstore/models/inofficial_api_models.dart';

class Player {
  PlayerInfo? playerInfo;
  Wallet? wallet;
  LevelBorder? levelBorder;
  Player({
    this.playerInfo,
    this.wallet,
    this.levelBorder,
  });
}

class Wallet {
  int? valorantPoints;
  int? radianitePoints;
  int? freeAgents;
  int? kingdomCredits;

  Wallet(
      {this.valorantPoints,
      this.radianitePoints,
      this.freeAgents,
      this.kingdomCredits});
}

class PlayerXP {
  int? version;
  String? subject;
  Progress? progress;
  List<History>? history;
  String? lastTimeGrantedFirstWin;
  String? nextTimeFirstWinAvailable;

  PlayerXP(
      {this.version,
      this.subject,
      this.progress,
      this.history,
      this.lastTimeGrantedFirstWin,
      this.nextTimeFirstWinAvailable});

  PlayerXP.fromJson(Map<String, dynamic> json) {
    version = json['Version'];
    subject = json['Subject'];
    progress =
        json['Progress'] != null ? Progress.fromJson(json['Progress']) : null;
    if (json['History'] != null) {
      history = <History>[];
      json['History'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
    lastTimeGrantedFirstWin = json['LastTimeGrantedFirstWin'];
    nextTimeFirstWinAvailable = json['NextTimeFirstWinAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Version'] = version;
    data['Subject'] = subject;
    if (progress != null) {
      data['Progress'] = progress!.toJson();
    }
    if (history != null) {
      data['History'] = history!.map((v) => v.toJson()).toList();
    }
    data['LastTimeGrantedFirstWin'] = lastTimeGrantedFirstWin;
    data['NextTimeFirstWinAvailable'] = nextTimeFirstWinAvailable;
    return data;
  }
}

class Progress {
  int? level;
  int? xP;

  Progress({this.level, this.xP});

  Progress.fromJson(Map<String, dynamic> json) {
    level = json['Level'];
    xP = json['XP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Level'] = level;
    data['XP'] = xP;
    return data;
  }
}

class History {
  String? iD;
  String? matchStart;
  Progress? startProgress;
  Progress? endProgress;
  int? xPDelta;
  List<XPSources>? xPSources;

  History({
    this.iD,
    this.matchStart,
    this.startProgress,
    this.endProgress,
    this.xPDelta,
    this.xPSources,
  });

  History.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    matchStart = json['MatchStart'];
    startProgress = json['StartProgress'] != null
        ? Progress.fromJson(json['StartProgress'])
        : null;
    endProgress = json['EndProgress'] != null
        ? Progress.fromJson(json['EndProgress'])
        : null;
    xPDelta = json['XPDelta'];
    if (json['XPSources'] != null) {
      xPSources = <XPSources>[];
      json['XPSources'].forEach((v) {
        xPSources!.add(XPSources.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['MatchStart'] = matchStart;
    if (startProgress != null) {
      data['StartProgress'] = startProgress!.toJson();
    }
    if (endProgress != null) {
      data['EndProgress'] = endProgress!.toJson();
    }
    data['XPDelta'] = xPDelta;
    if (xPSources != null) {
      data['XPSources'] = xPSources!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class XPSources {
  String? iD;
  int? amount;

  XPSources({this.iD, this.amount});

  XPSources.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    amount = json['Amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['Amount'] = amount;
    return data;
  }
}

class PlayerInfo {
  String? puuid;
  String? region;
  int? accountLevel;
  String? name;
  String? tag;
  Card? card;
  String? lastUpdate;
  int? lastUpdateRaw;

  PlayerInfo(
      {this.puuid,
      this.region,
      this.accountLevel,
      this.name,
      this.tag,
      this.card,
      this.lastUpdate,
      this.lastUpdateRaw});

  PlayerInfo.fromJson(Map<String, dynamic> json) {
    puuid = json['puuid'];
    region = json['region'];
    accountLevel = json['account_level'];
    name = json['name'];
    tag = json['tag'];
    card = json['card'] != null ? Card.fromJson(json['card']) : null;
    lastUpdate = json['last_update'];
    lastUpdateRaw = json['last_update_raw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['puuid'] = puuid;
    data['region'] = region;
    data['account_level'] = accountLevel;
    data['name'] = name;
    data['tag'] = tag;
    if (card != null) {
      data['card'] = card!.toJson();
    }
    data['last_update'] = lastUpdate;
    data['last_update_raw'] = lastUpdateRaw;
    return data;
  }
}

class Card {
  String? small;
  String? large;
  String? wide;
  String? id;

  Card({this.small, this.large, this.wide, this.id});

  Card.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    large = json['large'];
    wide = json['wide'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['large'] = large;
    data['wide'] = wide;
    data['id'] = id;
    return data;
  }
}
