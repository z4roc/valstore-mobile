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
