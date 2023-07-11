class Reauth {
  String? type;
  Response? response;
  String? country;

  Reauth({this.type, this.response, this.country});

  Reauth.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    data['country'] = country;
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
        ? Parameters.fromJson(json['parameters'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mode'] = mode;
    if (parameters != null) {
      data['parameters'] = parameters!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uri'] = uri;
    return data;
  }
}
