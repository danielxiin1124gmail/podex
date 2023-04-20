import 'package:pokedex/shared/models/pokemon.dart';
import 'package:pokedex/shared/models/pokemon_summary.dart';

class PokemonFilter {
  Generation? generationFilter;
  String? typeFilter;
  String? pokemonNameNumberFilter;

  PokemonFilter({
    this.generationFilter,
    this.typeFilter,
    this.pokemonNameNumberFilter,
  });

  PokemonFilter copyWith({
    Generation? generationFilter,
    String? typeFilter,
    String? pokemonNameNumberFilter,
  }) {
    return PokemonFilter(
      generationFilter: generationFilter ?? this.generationFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      pokemonNameNumberFilter:
          pokemonNameNumberFilter ?? this.pokemonNameNumberFilter,
    );
  }
  // 这边的 copyWith只是备用，让未来当PokemonFilter有些微变化时，更好引用，例如:
  // var pizza = FavoriteFoods(color: 'red', taste: 'savory', cost: '\$10.00');
  // var pizzaCopy = pizza.copyWith(cost: '\$12.00');
  // print('Original pizza cost: ${pizza.cost}');
  // print('Pizza copy cost: ${pizzaCopy.cost}');

  List<PokemonSummary>? filter(List<PokemonSummary>? pokemonsSummary) {
    var pokemons = pokemonsSummary;

    if (this.generationFilter != null) {
      pokemons = pokemons!
          .where((it) => it.generation == this.generationFilter)
          .toList();
    }
    // 这里就是说，当generationFilter非空时，it.generation = 使用者指定的generation。

    if (this.typeFilter != null) {
      pokemons =
          pokemons!.where((it) => it.types.contains(this.typeFilter)).toList();
    }
    // 这里原来是 it.types[0] == this.typeFilter).toList(); 他其实不合理。
    // 假设filter是筛选"grass"，然后A={grass, fire}、B={water、grass}，他其实只筛选出A，排除B。
    // 改成contains，这样B就不会被排除。他本来的[0]，意味着只拿[0]、即写在第一个的type来做筛选判断。
    // 但其实不该只看写在第一个的type，应该全部都要看才对，因此应该改成contains。

    if (this.pokemonNameNumberFilter != null &&
        this.pokemonNameNumberFilter!.trim().isNotEmpty) {
      // trim() is a built-in method in Dart that removes all whitespace
      // (spaces, tabs, and newlines) from the beginning and end of a string.
      // 第一段的!= null一定要有，否则Error，因为trim()不能用在null时；也就是说，
      // 当我们没有使用pokemonNameNumberFilter时，当此栏位是空的时，他会trim不了，会Error。
      // 有了两个判断式，才不会因为 null 而 error。
      pokemons = pokemons!
          .where((it) =>
              it.name
                  .toLowerCase()
                  .contains(this.pokemonNameNumberFilter!.toLowerCase()) ||
              it.number.contains(this.pokemonNameNumberFilter!))
          .toList();
    }
    // 必须有toLowerCase()，因为这个where 是 case-sensitive，所以把它先全部变成小写再搜，才会完整。

    return pokemons;
  }
}
