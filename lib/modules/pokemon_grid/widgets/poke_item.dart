import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/shared/models/pokemon_summary.dart';
import 'package:pokedex/shared/ui/canvas/white_pokeball_canvas.dart';
import 'package:pokedex/shared/utils/image_utils.dart';
import 'package:pokedex/theme/app_theme.dart';

class PokeItemWidget extends StatelessWidget {
  final PokemonSummary pokemon;
  final bool isFavorite;

  const PokeItemWidget(
      {Key? key, required this.pokemon, this.isFavorite = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getColors(context).pokemonItem(pokemon.types[0]),
        // 这里决定火、草、水等类别的卡片底色。[0]表示地一种属性。怪物可以有两种或只有一种属性，
        // 所以[0]代表第一个。不能[1]是因为有些怪兽只有一种属性。
        // 这边的BoxDecoration只影响了卡片底色的圆角。它不能再加上child属性。与下方ClipRRect有差异。
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        // 这是卡片内文的圆角，其实当删除后，可以在边边角角看到有个90度的半透明棱角。
        child: Stack(
          children: [
            // 下面 Positioned ，是怪兽卡片的右下方背景宝贝球设计。
            Positioned(
              bottom: -15,
              right: -3,
              child: Container(
                child: CustomPaint(
                  size: Size(
                      83,
                      (83 * 1.0040160642570282)
                          .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: PokeballLogoPainter(
                    color: Colors.white.withOpacity(0.3),
                    // 这个 PokeballLogoPainter 就是背景宝贝球的图案代码。
                  ),
                ),
              ),
            ),
            // 下面的 Align 是卡片中的怪物缩图位置。
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 7, bottom: 3),
                child: Container(
                  child: Hero(
                    tag: isFavorite
                        ? "favorite-pokemon-image-${pokemon.number}"
                        : "pokemon-image-${pokemon.number}",
                    child: ImageUtils.networkImage(
                      url: pokemon.thumbnailUrl,
                      // 怪兽卡片里的怪兽缩图，是API里面的网址。
                    ),
                  ),
                  height: 76,
                  width: 76,
                ),
              ),
            ),
            // 下面是怪兽编号。
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: Text(
                  "#${pokemon.number}",
                  style: TextStyle(
                    fontFamily: "CircularStd-Book",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getColors(context)
                        .pokemonDetailsTitleColor
                        .withOpacity(0.6),
                  ),
                ),
              ),
            ),
            // 下面是卡片左侧，怪兽名称、属性文字。
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name,
                    style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.getColors(context)
                            .pokemonDetailsTitleColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: pokemon.types
                        .map((type) => Padding(
                              padding:
                                  const EdgeInsets.only(top: 4), //这是俩种属性之间间距。
                              child: Container(
                                child: Padding(
                                  //这是俩种属性具体文字，与椭圆体色左右边界之间的间距。
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Text(
                                    type,
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontSize: 8,
                                      color: AppTheme.getColors(context)
                                          .pokemonDetailsTitleColor,
                                    ),
                                  ),
                                ),
                                // 这是属性区域，文字的椭圆长条底色。
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(38),
                                    color: AppTheme.getColors(context)
                                        .pokemonDetailsTitleColor
                                        .withOpacity(0.4)),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
