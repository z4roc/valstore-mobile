import 'dart:convert';

import 'package:http/http.dart';
import 'package:valstore/models/inofficial_api_models.dart';

class InofficialValorantAPI {
  Future<Map> getSkinById(String id) async => jsonDecode(
      (await get(Uri.parse("https://valorant-api.com/v1/weapons/$id"))).body);

  Future<Sprays> getSprays() async => Sprays.fromJson(jsonDecode(
      (await get(Uri.parse("https://valorant-api.com/v1/sprays"))).body));

  Future<Playercards> getPlayercards() async => Playercards.fromJson(jsonDecode(
      (await get(Uri.parse("https://valorant-api.com/v1/playercards"))).body));

  Future<PlayerTitles> getPlayerTitles() async =>
      PlayerTitles.fromJson(jsonDecode(
          (await get(Uri.parse("https://valorant-api.com/v1/playertitles")))
              .body));

  Future<List<DisplayableItem>> getAllDisplayableItems() async {
    final items = <DisplayableItem>[];

    final titles = await getPlayerTitles();

    items.addAll(titles.data as Iterable<DisplayableItem>);

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

  Future<dynamic> getCurrentVersion() async =>
      jsonDecode((await get(Uri.parse("https://valorant-api.com/v1/version")))
          .body)['data'];
}
