import 'package:flutter/material.dart';
import 'package:pokedex/shared/ui/canvas/white_pokeball_canvas.dart';
import 'package:pokedex/shared/utils/app_constants.dart';
import 'package:pokedex/theme/app_theme.dart';

class TennisPlayerBackhandStyleItemWidget extends StatelessWidget {
  final String backhandStyle;
  final Color? color;
  final VoidCallback onClick;

  const TennisPlayerBackhandStyleItemWidget(
      {Key? key,
      required this.backhandStyle,
      required this.onClick,
      this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onClick,
      enableFeedback: true,
      child: Container(
        // decoration 只是每个怪兽类型的widget的底色、圆角等设计。
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? color
              : Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(15),
          border: Border.fromBorderSide(
            BorderSide(color: AppTheme.getColors(context).tabDivisor),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.08),
              blurRadius: 1.0,
              spreadRadius: 1.0,
              offset: Offset(
                0.0,
                4.0,
              ),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // stack 第一1个东西，是卡片右下角的宝贝球背景图案。
              Positioned(
                bottom: -15,
                right: -15,
                child: Container(
                  child: CustomPaint(
                    size: Size(83, (83 * 1.0040160642570282).toDouble()),
                    painter: PokeballLogoPainter(
                      color: AppTheme.getColors(context)
                          .pokeballLogoGray
                          .withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              // stack 第一2个东西，是卡片左上角的宝贝球背景图案。
              Positioned(
                top: -45,
                left: -45,
                child: Container(
                  child: CustomPaint(
                    size: Size(83, (83 * 1.0040160642570282).toDouble()),
                    painter: PokeballLogoPainter(
                      color: AppTheme.getColors(context)
                          .pokeballLogoGray
                          .withOpacity(0.1),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          backhandStyle,
                          style: textTheme.bodyLarge,
                        ),
                        Image.asset(
                          AppConstants.tennisPlayerBackhandStyleLogo(
                              backhandStyle,
                              size: 60),
                          width: 60,
                          height: 60,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
