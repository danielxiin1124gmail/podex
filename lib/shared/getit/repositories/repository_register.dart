import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/shared/getit/getit.dart';
import 'package:pokedex/shared/repositories/item_repository.dart';
import 'package:pokedex/shared/repositories/tennisItem_repository.dart';
import 'package:pokedex/shared/repositories/pokemon_repository.dart';
import 'package:pokedex/shared/repositories/tennisPlayer_repository.dart';

class RepositoryRegister extends IGetItRegister {
  @override
  void register() {
    GetIt getIt = GetIt.instance;

    if (!GetIt.I.isRegistered<PokemonRepository>()) {
      getIt.registerSingleton<PokemonRepository>(PokemonRepository());
      // 如果尚未Registered，则触发 PokemonRepository()，他会去API获取怪兽Summary，做以下2件事:
      // 1. fetchPokemonsSummary --> return List<PokemonSummary>。
      // 2. fetchFavoritesPokemonsSummary --> return favorites。
      // 他并不会触发 Future<Pokemon> fetchPokemon(String number) async {...}
      // 因为我们并没有在此时、任何地方说 String number 是啥。
    }

    if (!GetIt.I.isRegistered<ItemRepository>()) {
      getIt.registerSingleton<ItemRepository>(ItemRepository(Dio()));
      // 这要点了 item清单，才会触发。
    }

    // 下面我加上的。
    if (!GetIt.I.isRegistered<TennisPlayerRepository>()) {
      getIt.registerSingleton<TennisPlayerRepository>(TennisPlayerRepository());
    }
    if (!GetIt.I.isRegistered<TennisItemRepository>()) {
      getIt
          .registerSingleton<TennisItemRepository>(TennisItemRepository(Dio()));
      // 这要点了 item清单，才会触发。
    }
  }
}
