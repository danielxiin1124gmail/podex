import 'package:get_it/get_it.dart';
import 'package:pokedex/modules/home/home_page_store.dart';
import 'package:pokedex/shared/getit/getit.dart';
import 'package:pokedex/shared/stores/item_store/item_store.dart';
import 'package:pokedex/shared/stores/tennisItem_store/tennisItem_store.dart';
import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

class StoreRegister extends IGetItRegister {
  @override
  void register() {
    GetIt getIt = GetIt.instance;

    if (!GetIt.I.isRegistered<PokemonStore>()) {
      getIt.registerSingleton<PokemonStore>(PokemonStore());
    }

    if (!GetIt.I.isRegistered<ItemStore>()) {
      getIt.registerSingleton<ItemStore>(ItemStore());
    }

    // 下面是我加的。
    if (!GetIt.I.isRegistered<TennisPlayerStore>()) {
      getIt.registerSingleton<TennisPlayerStore>(TennisPlayerStore());
    }
    if (!GetIt.I.isRegistered<TennisItemStore>()) {
      getIt.registerSingleton<TennisItemStore>(TennisItemStore());
    }

    if (!GetIt.I.isRegistered<HomePageStore>()) {
      getIt.registerSingleton<HomePageStore>(HomePageStore());
    }
  }
}
