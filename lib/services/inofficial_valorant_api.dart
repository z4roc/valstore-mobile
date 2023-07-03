import 'dart:convert';

import 'package:http/http.dart';
import 'package:valstore/models/inofficial_api_models.dart';

class InofficialValorantAPI {
  Future<Sprays> getSprays() async => Sprays.fromJson(jsonDecode(
      (await get(Uri.parse("https://valorant-api.com/v1/sprays"))).body));

  Future<Playercards> getPlayercards() async => Playercards.fromJson(jsonDecode(
      (await get(Uri.parse("https://valorant-api.com/v1/playercards"))).body));

  Future<List<DisplayableItem>> getAllDisplayableItems() async {
    final items = <DisplayableItem>[];

    items.addAll(Sprays.fromJson(jsonDecode(
            (await get(Uri.parse("https://valorant-api.com/v1/sprays"))).body))
        .sprays as Iterable<DisplayableItem>);

    items.addAll(Playercards.fromJson(jsonDecode(
            (await get(Uri.parse("https://valorant-api.com/v1/playercards")))
                .body))
        .sprays as Iterable<DisplayableItem>);

    items.addAll(Gunbuddies.fromJson(jsonDecode(
            (await get(Uri.parse("https://valorant-api.com/v1/buddies"))).body))
        .sprays as Iterable<DisplayableItem>);

    return items;
  }

  Future<LevelBorders> getLevelBorders() async =>
      LevelBorders.fromJson(jsonDecode(
          (await get(Uri.parse("https://valorant-api.com/v1/levelborders")))
              .body));
}
