import 'package:pokedex/shared/getit/repositories/repository_register.dart';
import 'package:pokedex/shared/getit/stores/store_register.dart';

abstract class IGetItRegister {
  void register();
}

class GetItRegister {
  static register() {
    print('<getit.dart> --> 准备执行 RepositoryRegister().register() ');
    RepositoryRegister().register();
    // RepositoryRegister() 的 register()做以下1件事:
    // 第一，执行 PokemonRepository，即 fetch 怪兽简介 与 fetch 我的最爱。
    // 虽然，代码里还有 ItemRepository，但可能是因为她带有ItemRepository(Dio())，所以未执行。
    // 要是点了菜单里的 Item，则会触发ItemRepository。
    print('<getit.dart> --> 准备执行 StoreRegister().register() ');
    StoreRegister().register();
  }
}
