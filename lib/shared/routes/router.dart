import 'package:flutter/material.dart';
import 'package:pokedex/modules/home/home_page.dart';
import 'package:pokedex/modules/items/items_page.dart';
import 'package:pokedex/modules/tennisItems/tennisItems_page.dart';
import 'package:pokedex/modules/tennisPlayer_grid/tennisPlayer_grid_page.dart';

abstract class Router {
  // 下面这貌似没有影响，乱改 "/items" ，items页面也正常执行。感觉没作用。
  static String home = "/";
  static String items = "/items";
  static String tennisItems = "/tennisItems";
  static String tennisPlayers = "/tennisPlayers";

  static Map<String, WidgetBuilder> getRoutes(context) {
    return {
      home: (context) => HomePage(), // 这里不能乱改。
      items: (context) => ItemsPage(),
      // 但是，这里乱改成 Container()，一切正常。
      tennisItems: (context) => TennisItemsPage(),
      // 但是，这里乱改成 Container()，也是一切正常。
      tennisPlayers: (context) => TennisPlayerGridPage(),
    };
  }
}
