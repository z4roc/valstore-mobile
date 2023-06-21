class Reauth {
  String? type;
  Response? response;
  String? country;

  Reauth({this.type, this.response, this.country});

  Reauth.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['country'] = this.country;
    return data;
  }
}

class Response {
  String? mode;
  Parameters? parameters;

  Response({this.mode, this.parameters});

  Response.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    parameters = json['parameters'] != null
        ? new Parameters.fromJson(json['parameters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mode'] = this.mode;
    if (this.parameters != null) {
      data['parameters'] = this.parameters!.toJson();
    }
    return data;
  }
}

class Parameters {
  String? uri;

  Parameters({this.uri});

  Parameters.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uri'] = this.uri;
    return data;
  }
}
