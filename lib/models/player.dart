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
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
    lastUpdate = json['last_update'];
    lastUpdateRaw = json['last_update_raw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['puuid'] = this.puuid;
    data['region'] = this.region;
    data['account_level'] = this.accountLevel;
    data['name'] = this.name;
    data['tag'] = this.tag;
    if (this.card != null) {
      data['card'] = this.card!.toJson();
    }
    data['last_update'] = this.lastUpdate;
    data['last_update_raw'] = this.lastUpdateRaw;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['small'] = this.small;
    data['large'] = this.large;
    data['wide'] = this.wide;
    data['id'] = this.id;
    return data;
  }
}
