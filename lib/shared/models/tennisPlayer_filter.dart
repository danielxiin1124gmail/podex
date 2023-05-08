import 'package:pokedex/shared/models/pokemon.dart';
import 'package:pokedex/shared/models/tennisPlayer.dart';
import 'package:pokedex/shared/models/pokemon_summary.dart';
import 'package:pokedex/shared/models/tennisPlayer_summary.dart';

class TennisPlayerFilter {
  String? tennisPlayerNameNumberFilter;
  String? typeFilter;
  String? styleFilter;
  String? countryFilter;
  String? rightOrLeftFilter;
  String? backhandStyleFilter;

  TennisPlayerFilter({
    this.tennisPlayerNameNumberFilter,
    this.typeFilter,
    this.styleFilter,
    this.countryFilter,
    this.rightOrLeftFilter,
    this.backhandStyleFilter,
  });

  TennisPlayerFilter copyWith({
    String? tennisPlayerNameNumberFilter,
    String? typeFilter,
    String? styleFilter,
    String? countryFilter,
    String? rightOrLeftFilter,
    String? backhandStyleFilter,
  }) {
    return TennisPlayerFilter(
      tennisPlayerNameNumberFilter:
          tennisPlayerNameNumberFilter ?? this.tennisPlayerNameNumberFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      styleFilter: styleFilter ?? this.styleFilter,
      countryFilter: countryFilter ?? this.countryFilter,
      rightOrLeftFilter: rightOrLeftFilter ?? this.rightOrLeftFilter,
      backhandStyleFilter: backhandStyleFilter ?? this.backhandStyleFilter,
    );
  }
  // 这边的 copyWith只是备用，让未来当PokemonFilter有些微变化时，更好引用，例如:
  // var pizza = FavoriteFoods(color: 'red', taste: 'savory', cost: '\$10.00');
  // var pizzaCopy = pizza.copyWith(cost: '\$12.00');
  // print('Original pizza cost: ${pizza.cost}');
  // print('Pizza copy cost: ${pizzaCopy.cost}');

  List<TennisPlayerSummary>? filter(
      List<TennisPlayerSummary>? tennisPlayersSummary) {
    var tennisPlayers = tennisPlayersSummary;

    if (this.tennisPlayerNameNumberFilter != null &&
        this.tennisPlayerNameNumberFilter!.trim().isNotEmpty) {
      // trim() is a built-in method in Dart that removes all whitespace
      // (spaces, tabs, and newlines) from the beginning and end of a string.
      // 第一段的!= null一定要有，否则Error，因为trim()不能用在null时；也就是说，
      // 当我们没有使用pokemonNameNumberFilter时，当此栏位是空的时，他会trim不了，会Error。
      // 有了两个判断式，才不会因为 null 而 error。
      tennisPlayers = tennisPlayers!
          .where((it) =>
              it.name
                  .toLowerCase()
                  .contains(this.tennisPlayerNameNumberFilter!.toLowerCase()) ||
              it.number.contains(this.tennisPlayerNameNumberFilter!))
          .toList();
    }
    // 必须有toLowerCase()，因为这个where 是 case-sensitive，所以把它先全部变成小写再搜，才会完整。

    if (this.typeFilter != null) {
      tennisPlayers = tennisPlayers!
          .where((it) => it.types.contains(this.typeFilter))
          .toList();
    }
    // 这里原来是 it.types[0] == this.typeFilter).toList(); 他其实不合理。
    // 假设filter是筛选"grass"，然后A={grass, fire}、B={water、grass}，他其实只筛选出A，排除B。
    // 改成contains，这样B就不会被排除。他本来的[0]，意味着只拿[0]、即写在第一个的type来做筛选判断。
    // 但其实不该只看写在第一个的type，应该全部都要看才对，因此应该改成contains。

    if (this.styleFilter != null) {
      tennisPlayers = tennisPlayers!
          .where((it) => it.style.contains(this.styleFilter!))
          .toList();
      // 这边我本来是抄 typeFilter，但是 typeFilter 是 List<String>，而 style只是 String。
      // 区别是，照抄会 error，必须在最后面加惊叹号。it.style.contains(this.styleFilter!)。
    }
    if (this.countryFilter != null) {
      tennisPlayers = tennisPlayers!
          .where((it) => it.country.contains(this.countryFilter!))
          .toList();
    }
    if (this.rightOrLeftFilter != null) {
      tennisPlayers = tennisPlayers!
          .where((it) => it.rightOrLeft.contains(this.rightOrLeftFilter!))
          .toList();
    }
    if (this.backhandStyleFilter != null) {
      tennisPlayers = tennisPlayers!
          .where((it) => it.backhandStyle.contains(this.backhandStyleFilter!))
          .toList();
    }

    return tennisPlayers;
  }
}
