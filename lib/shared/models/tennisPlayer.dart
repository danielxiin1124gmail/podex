class TennisPlayer {
  late String number;
  late String name;
  late String imageUrl;
  late String apiAddress;
  late List<String> types;
  late String style;
  late String country;
  late String rightOrLeft;
  late String backhandStyle;
  late List<String> descriptions;
  late BaseStats baseStats;
  late String? soundUrl;

  TennisPlayer({
    required this.number,
    required this.name,
    required this.imageUrl,
    required this.apiAddress,
    required this.types,
    required this.style,
    required this.country,
    required this.rightOrLeft,
    required this.backhandStyle,
    required this.descriptions,
    required this.baseStats,
    this.soundUrl,
  });

  TennisPlayer.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    apiAddress = json['apiAddress'];
    types = json['types'].cast<String>();
    style = json['style'];
    country = json['country'];
    rightOrLeft = json['rightOrLeft'];
    backhandStyle = json['backhandStyle'];
    // 解释: By calling .cast<String>() on them, the code is converting these lists to a list of strings
    descriptions = json['descriptions'].cast<String>();
    baseStats = BaseStats.fromJson(json['baseStats']);
    soundUrl = json['soundUrl'];
  }

  // 下面的 operator 有点玄，先放著。
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TennisPlayer &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;

  // 我没搜到到底哪里有使用 toString。估计。。。没用到？ pokemon.dart里面的 toString也没搜到哪里用了。
  // 而且为啥变数后面要紧跟著逗号？ 尚不明白。
  // 我觉得，他是override toString，也就是说许多用到 toString的地方都被它定义了。
  @override
  String toString() {
    return 'Pokemon{number: $number, '
        'name: $name, '
        'imageUrl: $imageUrl, '
        'apiAddress: $apiAddress, '
        'types: $types, '
        'style: $style, '
        'country: $country, '
        'rightOrLeft: $rightOrLeft, '
        'backhandStyle: $backhandStyle, '
        'descriptions: $descriptions, '
        'baseStats: $baseStats, '
        'soundUrl: $soundUrl, ';
  }
}

enum BackhandStyle {
  One_Handed_Backhand,
  Two_Handed_Backhand,

  //GENERATION_I has a value of 0, GENERATION_II has a value of 1, and so on
}

extension BackhandStyleExtension on BackhandStyle {
  String get description {
    switch (this) {
      case BackhandStyle.One_Handed_Backhand:
        return "One Handed Backhand";
      case BackhandStyle.Two_Handed_Backhand:
        return "Two Handed Backhand";
      default:
        return "All Types";
    }
  }

  // 这是 generation_item.dart用的，就是 generation filter要用到的，这里先暂缓。
  int get number {
    switch (this) {
      case BackhandStyle.One_Handed_Backhand:
        return 1;
      case BackhandStyle.Two_Handed_Backhand:
        return 2;
      default:
        return 0;
    }
  }
}

class BaseStats {
  late int fh;
  late int bh;
  late int srv;
  late int vol;
  late int pow;
  late int sta;
  late int spe;

  BaseStats(
      {required this.fh,
      required this.bh,
      required this.srv,
      required this.vol,
      required this.pow,
      required this.sta,
      required this.spe});

  BaseStats.fromJson(Map<String, dynamic> json) {
    fh = json['fh'];
    bh = json['bh'];
    srv = json['srv'];
    vol = json['vol'];
    pow = json['pow'];
    sta = json['sta'];
    spe = json['spe'];
  }
}
