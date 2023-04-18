import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex/modules/pokemon_grid/widgets/pokemon_grid.dart';
import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/utils/app_constants.dart';

class PokemonGridPage extends StatefulWidget {
  // 这里是stateFul，但我的最爱的浮窗是stateLess，尚未明白为何不同。
  // ChatGPT说，因为 PokemonStore 要从API fetch data，且 Observer 会listens to changes in the PokemonStore，
  // 所以 PokemonGridPage 需要是 statefulWidget。
  // 此外，下面有显示搜索成果，随时搜、随时改结果，那么更应该是 statefulWidget。
  PokemonGridPage({Key? key}) : super(key: key);

  @override
  _PokemonGridPageState createState() => _PokemonGridPageState();
}

class _PokemonGridPageState extends State<PokemonGridPage> {
  late PokemonStore _pokemonStore;

  @override
  void initState() {
    super.initState();

    _pokemonStore = GetIt.instance<PokemonStore>();
    // 没他，直接error。
    // 此外，items_page.dart也有类似的这行，但那个前面有加 final，这个没有，加了会error。

    _fetchPokemonData();
    // 没他，虽然不会直接error，但会首页转圈圈无法显示怪兽。
    // 其实可以把 _fetchPokemonData(); 改成下面的 _pokemonStore.fetchPokemonData();。
    // 不会error；但是别加上 async / await，那就会error。因为 iniState其实不能使用async。
    // 但不会红底线。
  }

  // 下面就是去fetch 所有怪兽。
  Future<void> _fetchPokemonData() async {
    print('<pokemon_grid_page> 这页面呼叫了 _fetchPokemonData');
    await _pokemonStore.fetchPokemonData();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Observer(
      builder: (_) {
        // 下面是，如果还没有成功fetch到怪兽时，展示CircularProgressIndicator。
        if (_pokemonStore.pokemonsSummary == null) {
          // if 还没fetch，则显示CircularProgressIndicator()。
          // 这里非得要先来个 SliverFillRemaining 包住 CircularProgressIndicator，不然error。
          return SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          );
        } else {
          // 下面是，当有filter作用时，但是乱搜个999时，展示"搜不到"的画面。
          if (_pokemonStore.pokemonFilter.pokemonNameNumberFilter != null &&
              _pokemonStore.pokemonsSummary!.isEmpty) {
            return SliverToBoxAdapter(
              // ChatGPT说，因为下面有Stack，Stack若要使用在Silver系列功能时，
              // 得包在SliverToBoxAdapter 的 container 里面。
              child: Container(
                height: 250,
                width: 250,
                child: Stack(
                  children: [
                    Center(
                      child: Lottie.asset(
                        AppConstants.pikachuLottie,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(
                          "${_pokemonStore.pokemonFilter.pokemonNameNumberFilter} was not found",
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          // 下面是，当没有filter筛选时，展示所有宝贝。
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: PokemonGridWidget(pokemonStore: _pokemonStore),
            // 我判断，一但搜索成功，应该会返回符合搜索关键字的_pokemonStore，然后只显示相关内容。
            // 到底怎样获取、更新_pokemonStore，我当前还没看明白。
          );
        }
      },
    );
  }
}
