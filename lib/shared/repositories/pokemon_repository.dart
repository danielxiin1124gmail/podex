import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex/shared/models/pokemon.dart';
import 'package:pokedex/shared/models/pokemon_summary.dart';
import 'package:pokedex/shared/utils/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonRepository {
  Future<List<PokemonSummary>> fetchPokemonsSummary() async {
    print('<pokemon_repository.dart> 触发了 fetchPokemonsSummary()');
    try {
      final response =
          await http.get(Uri.parse(ApiConstants.pokedexSummaryData));
      //到他的API获取怪兽Summary。
      print('<print> --->  ${response.body}');

      return List<PokemonSummary>.from(
        json.decode(Utf8Decoder().convert(response.body.codeUnits)).map(
              (model) => PokemonSummary.fromJson(model),
            ),
      );
      //return一个list of PokemonSummary，然后decode他。
    } catch (e) {
      throw e;
    }
  }

  Future<List<String>> fetchFavoritesPokemonsSummary() async {
    print('<pokemon_repository.dart> 触发了 fetchFavoritesPokemonsSummary()');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final favorites = prefs.getStringList('favorites-pokemons');
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

  Future<Pokemon> fetchPokemon(String number) async {
    print('<pokemon_repository.dart> 触发了 fetchPokemon()');
    try {
      final response =
          await http.get(Uri.parse(ApiConstants.pokemonDetails(number)));

      return Pokemon.fromJson(
          jsonDecode(Utf8Decoder().convert(response.body.codeUnits)));
    } catch (e) {
      throw e;
    }
  }

  void saveFavoritePokemonSummary(List<String> favorites) async {
    print('<pokemon_repository.dart> 触发了 saveFavoritePokemonSummary()');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites-pokemons', favorites);
    } catch (e) {
      throw e;
    }
  }
}
