import 'dart:convert';

class TennisItem {
  final String name;
  final String? imageUrl;
  final String category;

  TennisItem({
    required this.name,
    this.imageUrl,
    required this.category,
  });

  TennisItem copyWith({
    String? name,
    String? imageUrl,
    String? category,
  }) {
    return TennisItem(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      // if the parameter name is not null, it will be assigned to the name field
      // of the newly created Item object. If name is null, then the current value
      // of this.name will be assigned to name.
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory TennisItem.fromMap(Map<String, dynamic> map) {
    return TennisItem(
      name: map['name'],
      imageUrl: map['imageUrl'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap()); // 不知道意义何在。
  // 不知道意义何在。在此我以为从API获取资料后，只要JSON decode，为何有encode需求?
  factory TennisItem.fromJson(String source) =>
      TennisItem.fromMap(json.decode(source));

  @override
  // 不知道意义何在。ChatGPT说是debug时方便。这样打印 tennisIte.toString好像能看三个变数结果。
  String toString() {
    return 'Item(name: $name, imageUrl: $imageUrl, category: $category, )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    // 有个新的、需要被确认的东西叫做"other"，在此确认 if "this与other" 是否 identical。
    // 当前尚不明白实际应用上，有啥需要确认雷同与否的地方。
    return other is TennisItem &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.category == category;
  }

  @override
  int get hashCode {
    return name.hashCode ^ imageUrl.hashCode ^ category.hashCode;
    // "^"，这符号，是所谓 bitwise XOR (exclusive or) operator in binary arithmetic。
    // 假设 apple 的 hash code = 101，orange = 001，则 apple^orange = 100。
    // If both bits are 0 or both bits are 1, the result is 0.
    // Otherwise, the result is 1.
    // 至于，这 get hashCode 用意何在，应用在哪，待研究。
  }
}
