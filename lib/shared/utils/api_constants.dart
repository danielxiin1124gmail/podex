class ApiConstants {
  static String get pokedexSummaryData =>
      "https://pokedex.alansantos.dev/api/pokemons.json";

  static String pokemonDetails(String number) =>
      "https://pokedex.alansantos.dev/api/pokemons/$number.json";

  static String get pokemonItems =>
      "https://pokedex.alansantos.dev/api/items.json";

  static String get tennisItems =>
      "https://api.json-generator.com/templates/58lqvQqKQdsU/data?access_token=5xcoabyb696920y7245s60wcmadrjrfjih8xgjir";

  static String tennisPlayerDetails(String apiAddress) =>
      "https://api.json-generator.com/templates/$apiAddress/data?access_token=jw8kg0ympy1qkt77n6xys0q39ybvu5b0oxp09i29";

  static String get tennisPlayersSummaryData =>
      "https://api.json-generator.com/templates/9AmRwfMnyNIX/data?access_token=jw8kg0ympy1qkt77n6xys0q39ybvu5b0oxp09i29";
}
