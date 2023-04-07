import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/shared/getit/getit.dart';
import 'package:pokedex/shared/repositories/item_repository.dart';
import 'package:pokedex/shared/repositories/pokemon_repository.dart';

class RepositoryRegister extends IGetItRegister {
  @override
  void register() {
    GetIt getIt = GetIt.instance;

    if (!GetIt.I.isRegistered<PokemonRepository>()) {
      print(
          '<repository_register.dart> --> 准备执行 getIt.registerSingleton<PokemonRepository>(PokemonRepository() ');
      getIt.registerSingleton<PokemonRepository>(PokemonRepository());
      // 如果尚未Registered，则触发 PokemonRepository()，他会去API获取怪兽Summary，做以下2件事:
      // 1. fetchPokemonsSummary --> return List<PokemonSummary>。
      // 2. fetchFavoritesPokemonsSummary --> return favorites。
      // 他并不会触发 Future<Pokemon> fetchPokemon(String number) async {...}
      // 因为我们并没有在此时、任何地方说 String number 是啥。
    }

    if (!GetIt.I.isRegistered<ItemRepository>()) {
      print(
          '<repository_register.dart> --> 准备执行 getIt.registerSingleton<ItemRepository>(ItemRepository(Dio()) ');
      getIt.registerSingleton<ItemRepository>(ItemRepository(Dio()));
      // 这要点了 item清单，才会触发。
    }
  }
}
