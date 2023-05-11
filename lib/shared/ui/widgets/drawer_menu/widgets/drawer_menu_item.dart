import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/shared/ui/widgets/pokeball.dart';
import 'package:pokedex/theme/app_theme.dart';

class DrawerMenuItemWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double height;
  final double width;
  final VoidCallback? onTap;

  const DrawerMenuItemWidget(
      {Key? key,
      required this.color,
      required this.text,
      this.height = 60,
      this.width = 155,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        // 如果，六个菜单中，没写上onTap，就是null，那就显示"Not implemented yet"。
        onTap: onTap != null
            ? onTap
            : () {
                BotToast.showText(text: "Not implemented yet");
              },
        child: Container(
          decoration: BoxDecoration(
            color: onTap != null
                ? color
                : AppTheme.getColors(context).drawerDisabled,
            // 如果没有onTap功能，则颜色(灰色)的腻称叫做drawerDisabled。
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // 这是六个菜单上，背景的宝贝球设定。但是，当前颜色、大小变不了。得去pokeball.dart里面改。
                // 详细说明，看pokeball.dart。
                Positioned(
                  top: -12,
                  right: -14,
                  child: PokeballWidget(
                    size: 83,
                    color: Colors.white.withOpacity(0.2),
                    // 这边颜色定义没有意义，因为pokeball.dart已定义式白色，覆盖了这边的颜色设定。
                  ),
                ),
                // 这是左上角的小白球，好看而已。
                Positioned(
                  top: -60,
                  left: -50,
                  child: PokeballWidget(
                    size: 83,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        text,
                        style:
                            textTheme.bodyLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
