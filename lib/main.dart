import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/shared/getit/getit.dart';
import 'package:pokedex/shared/routes/router.dart' as router;
import 'package:pokedex/theme/dark/dark_theme.dart';
import 'package:pokedex/theme/light/light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //这句必须有，否则Error。若要使用platform-specific features，则需有上面这行。何谓platform-specific？
  //例如Camera access / Push notifications / File system access / User interface elements 等。
  SharedPreferences.getInstance().then((instance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //这是让SharedPreferences读取用户数据，例如已添加到我的最爱的怪兽。

    WidgetsFlutterBinding.ensureInitialized();
    //ChatGPT说上面这句是多余的，不用写两次。

    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      setWindowTitle('Pokédex by Alan Santos');
      setWindowMinSize(const Size(1366, 768));
      //若不是web，且是a或b或c，则...。
    }

    runApp(MyApp(prefs));
    //MyApp要带入perfs，才能读取用户基本设定数据。当然，MyApp也得设定好Constructor。
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  const MyApp(this.prefs);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('<main> --> 准备执行 GetItRegister.register() ');
    GetItRegister.register();
    print('<main> --> 准备执行 botToastBuilder = BotToastInit(); ');
    final botToastBuilder = BotToastInit();
    // 用了这package，意义好像是让推送 Toast 更简单。
    print('<main> --> 准备执行 return ThemeProvider ');
    return ThemeProvider(
      initTheme:
          this.prefs.getBool("darkTheme") ?? false ? darkTheme : lightTheme,
      child: MaterialApp(
        title: 'Pokedex',
        builder: (context, child) {
          child = botToastBuilder(context, child);
          return child;
          // 这边的 builder，即 botToastBuilder，其实只是为了当新增/解除我的最爱时弹出Toast。
        },
        theme: lightTheme, // 这不起任何作用。上面的 initTheme 才是决定日夜模式的地方。
        navigatorObservers: [BotToastNavigatorObserver()],
        // nagiOb 目的是侦测 navigation events 与显示 toast。
        debugShowCheckedModeBanner: false,
        routes: router.Router.getRoutes(context),
        initialRoute: "/",
      ),
    );
  }
}
