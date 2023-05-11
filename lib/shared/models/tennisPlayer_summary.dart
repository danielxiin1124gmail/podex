//import 'package:pokedex/shared/models/pokemon.dart';

class TennisPlayerSummary {
  late String number;
  late String name;
  late String imageUrl;
  late String thumbnailUrl; // summary 多了此数据了。
  late String apiAddress;
  late List<String> types;
  late String style;
  late String country;
  late String rightOrLeft;
  late String backhandStyle;
  //late List<String> descriptions;  // summary 就省去此数据了。
  //late BaseStats baseStats;  // summary 就省去此数据了。
  //late String? soundUrl;  // summary 就省去此数据了。

  TennisPlayerSummary({
    required this.number,
    required this.name,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.apiAddress,
    required this.types,
    required this.style,
    required this.country,
    required this.rightOrLeft,
    required this.backhandStyle,
  });

  // 注意!!! json['country'] 里面的大小写一定要与JSON的一样。
  // 我一开始这里是 country ，但是 JSON 里面不小心写成 Country，他会说类似 null cannot be String。
  // 意思就是说，他无法在JSON找到"country(小写)"，所以return "null"，那么null 自然无法是 country的String。
  TennisPlayerSummary.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    thumbnailUrl = json['thumbnailUrl'];
    apiAddress = json['apiAddress'];
    types = json['types'].cast<String>();
    style = json['style'];
    country = json['country'];
    rightOrLeft = json['rightOrLeft'];
    backhandStyle = json['backhandStyle'];
  }
}
