import 'package:flutter/material.dart';
import 'package:pokedex/shared/ui/canvas/white_pokeball_canvas.dart';

class PokeballWidget extends StatelessWidget {
  final double size;
  final Color color;

  const PokeballWidget({Key? key, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(83, (83 * 1.0040160642570282).toDouble()),
      painter: PokeballLogoPainter(
        color: Colors.white.withOpacity(0.2),
        // 上面这color有点多余。他在这里重复定义颜色是white，会导致其他页面，例如drawer_menu_item.dart，
        // 如果要改颜色，改不了，依然会被这里洗刷掉。把它变成 color: color, 就能解决问题。
      ),
    );
  }
}
