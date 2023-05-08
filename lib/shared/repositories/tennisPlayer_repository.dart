import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:pokedex/shared/models/pokemon.dart';
import 'package:pokedex/shared/models/tennisPlayer.dart';

import 'package:pokedex/shared/models/pokemon_summary.dart';
import 'package:pokedex/shared/models/tennisPlayer_summary.dart';

import 'package:pokedex/shared/utils/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TennisPlayerRepository {
  Future<List<TennisPlayerSummary>> fetchTennisPlayersSummary() async {
    try {
      final response =
          //await http.get(Uri.parse(ApiConstants.pokedexSummaryData));
          await http.get(Uri.parse(ApiConstants.tennisPlayersSummaryData));
      print('<print> --->  ${response.body}');
      //到他的API获取怪兽Summary。

      return List<TennisPlayerSummary>.from(
        json.decode(Utf8Decoder().convert(response.body.codeUnits)).map(
              (model) => TennisPlayerSummary.fromJson(model),
            ),
      );
      // 这里他 for each model, map to TennisPlayerSummary。他的model，就是API里面每个球员的基本资料。
      // 一份球员的基本资料叫做一个model，JSON里面有用刮号分开，所以它会知道哪些信息叫做一个"model"。
    } catch (e) {
      throw e;
    }
  }

  Future<TennisPlayer> fetchTennisPlayer(String apiAddress) async {
    try {
      final response = await http
          .get(Uri.parse(ApiConstants.tennisPlayerDetails(apiAddress)));

      return TennisPlayer.fromJson(
          jsonDecode(Utf8Decoder().convert(response.body.codeUnits)));
    } catch (e) {
      throw e;
    }
  }

  Future<List<String>> fetchFavoritesTennisPlayersSummary() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites-tennisPlayers');
      // favorites = [001, 003, 004, 008]

      if (favorites == null) {
        return [];
      } else {
        return favorites;
      }
    } catch (e) {
      throw e;
    }
  }

  void saveFavoriteTennisPlayerSummary(List<String> favorites) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites-tennisPlayers', favorites);
    } catch (e) {
      throw e;
    }
  }
}
