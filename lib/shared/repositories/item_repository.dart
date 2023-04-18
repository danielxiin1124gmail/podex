import 'package:dio/dio.dart';
import 'package:pokedex/shared/models/item.dart';
import 'package:pokedex/shared/utils/api_constants.dart';

class ItemRepository {
  final Dio dio;

  ItemRepository(this.dio);

  Future<List<Item>> fetchItems() async {
    print('触发了 fetchItems()');
    try {
      final response = await dio.get(ApiConstants.pokemonItems);
      // 其实，他演示了用 http 与 dio 两种 package的差异。ChatGPT说dio 进阶功能比较多。
      // In summary, dio automatically decodes the response data, while http requires manual decoding.

      return List<Item>.from(
        response.data.map(
          (model) => Item.fromMap(model),
        ),
      );
    } catch (e) {
      throw e;
    }
  }
}
