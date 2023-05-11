import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedex/shared/ui/widgets/animated_pokeball.dart';
import 'package:pokedex/theme/app_theme.dart';

import '../../utils/app_constants.dart';
import '../enums/device_screen_type.dart';

class AppBarWidget extends StatefulWidget {
  final String title;
  final String? lottiePath;

  const AppBarWidget({Key? key, required this.title, this.lottiePath})
      : super(key: key);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      // snap与floating一起true的话，会使appBar在下滑开始时就展开。当前皆false，则appBar会在
      // 下滑到顶端时才展开。
      expandedHeight: 170.0,
      collapsedHeight: 70,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
      actions: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
              // endDrawer有个child，名为DrawerMenuWidget，这才是真正抽屉画面所在。
              // 这里之所以能openEndDrawer，主要是在home_page.dart有写child: DrawerMenuWidget()。
            },
            icon: Icon(Icons.menu,
                color: AppTheme.getColors(context).appBarButtons),
            // 上面是动设定菜单图标颜色。
          ),
        )
      ],
      // 下面是调整首页那只乌龟的位置
      flexibleSpace: Stack(children: [
        FlexibleSpaceBar(
          centerTitle: false,
          background: widget.lottiePath != null
              ? Align(
                  alignment:
                      Alignment.bottomRight, // topLeft的话会跑到Pokemon标题后面 (stack)。
                  child: Lottie.asset(widget.lottiePath!, height: 140.0),
                )
              : Container(),
          titlePadding: EdgeInsets.only(left: 15, bottom: 10), // Pokemon字体位置。
          title: Row(
            children: [
              AnimatedPokeballWidget(
                size: 24,
                color: AppTheme.getColors(context).pokeballLogoBlack,
                // 上面决定宝贝球的颜色。getColors --> AppColorsDark() --> pokeballLogoBlack => Color(0xFFD8D8D8)
                // 代码中最后一个词是"pokeballLogoBlack"，代表颜色定义在app_color_dark.dart里的该词所定义的颜色。
              ),
              SizedBox(
                width: 5,
              ),
              Text(widget.title, style: textTheme.displayLarge),
              if (kIsWeb &&
                  getDeviceScreenType(context) != DeviceScreenType.CELLPHONE)
                SizedBox(
                  width: 5,
                ),
              if (kIsWeb &&
                  getDeviceScreenType(context) != DeviceScreenType.CELLPHONE)
                Image.network(
                  AppConstants.getRandomPokemonGif(),
                  height: 32,
                  // 上面这if，是当非手机画面时，随机新增一个gif。但奇怪的是，一般网页能读取gif，但app无法正常显示。
                )
            ],
          ),
        ),
      ]),
    );
  }
}
