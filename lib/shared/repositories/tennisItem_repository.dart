import 'package:dio/dio.dart';
import 'package:pokedex/shared/models/tennisItem.dart';
import 'package:pokedex/shared/utils/api_constants.dart';

class TennisItemRepository {
  final Dio dio;
  // Dio 主要是 is used for making HTTP requests in Dart。
  // 下面有"get(ApiConstants.pokemonItems)"，要去网址(API)获取信息，所以要这支持HTTP的东西。

  TennisItemRepository(this.dio);

  Future<List<TennisItem>> fetchTennisItems() async {
    print('触发了 fetchTennisItems()');
    try {
      final response = await dio.get(ApiConstants.tennisItems);
      // 其实，他演示了用 http 与 dio 两种 package的差异。ChatGPT说dio 进阶功能比较多。
      // In summary, dio automatically decodes the response data, while http requires manual decoding.

      return List<TennisItem>.from(
        response.data.map(
          (model) => TennisItem.fromMap(model),
        ),
      );
    } catch (e) {
      throw e;
    }
  }
}
