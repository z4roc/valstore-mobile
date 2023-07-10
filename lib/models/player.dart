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
    progress = json['Progress'] != null
        ? new Progress.fromJson(json['Progress'])
        : null;
    if (json['History'] != null) {
      history = <History>[];
      json['History'].forEach((v) {
        history!.add(new History.fromJson(v));
      });
    }
    lastTimeGrantedFirstWin = json['LastTimeGrantedFirstWin'];
    nextTimeFirstWinAvailable = json['NextTimeFirstWinAvailable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Version'] = this.version;
    data['Subject'] = this.subject;
    if (this.progress != null) {
      data['Progress'] = this.progress!.toJson();
    }
    if (this.history != null) {
      data['History'] = this.history!.map((v) => v.toJson()).toList();
    }
    data['LastTimeGrantedFirstWin'] = this.lastTimeGrantedFirstWin;
    data['NextTimeFirstWinAvailable'] = this.nextTimeFirstWinAvailable;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Level'] = this.level;
    data['XP'] = this.xP;
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
  List<int>? xPMultipliers;

  History(
      {this.iD,
      this.matchStart,
      this.startProgress,
      this.endProgress,
      this.xPDelta,
      this.xPSources,
      this.xPMultipliers});

  History.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    matchStart = json['MatchStart'];
    startProgress = json['StartProgress'] != null
        ? new Progress.fromJson(json['StartProgress'])
        : null;
    endProgress = json['EndProgress'] != null
        ? new Progress.fromJson(json['EndProgress'])
        : null;
    xPDelta = json['XPDelta'];
    if (json['XPSources'] != null) {
      xPSources = <XPSources>[];
      json['XPSources'].forEach((v) {
        xPSources!.add(new XPSources.fromJson(v));
      });
    }
    if (json['XPMultipliers'] != null) {
      xPMultipliers = <int>[];
      json['XPMultipliers'].forEach((v) {
        xPMultipliers!.add(int.tryParse(v) ?? 0);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['MatchStart'] = this.matchStart;
    if (this.startProgress != null) {
      data['StartProgress'] = this.startProgress!.toJson();
    }
    if (this.endProgress != null) {
      data['EndProgress'] = this.endProgress!.toJson();
    }
    data['XPDelta'] = this.xPDelta;
    if (this.xPSources != null) {
      data['XPSources'] = this.xPSources!.map((v) => v.toJson()).toList();
    }
    if (this.xPMultipliers != null) {
      data['XPMultipliers'] = this.xPMultipliers!.toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Amount'] = this.amount;
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
