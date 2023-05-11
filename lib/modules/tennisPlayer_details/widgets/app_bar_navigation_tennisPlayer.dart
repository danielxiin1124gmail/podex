import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

import 'package:pokedex/shared/utils/image_utils.dart';
import 'package:pokedex/theme/app_theme.dart';

class AppBarNavigationWidgetForTennisPlayer extends StatelessWidget {
  final _tennisPlayerStore = GetIt.instance<TennisPlayerStore>();

  AppBarNavigationWidgetForTennisPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme themeData = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_tennisPlayerStore.index > 0)
          InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.getColors(context).tennisPlayerDetailsTitleColor,
            ),
            onTap: () async {
              _tennisPlayerStore.previousTennisPlayer();
            },
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 6, right: 5),
          child: ImageUtils.networkImage(
              height: 35,
              width: 35,
              url: _tennisPlayerStore.tennisPlayer!.imageUrl),
        ),
        Text(
          _tennisPlayerStore.tennisPlayer!.name,
          style: themeData.headlineSmall?.copyWith(
            color: AppTheme.getColors(context).tennisPlayerDetailsTitleColor,
          ),
        ),
        SizedBox(
          width: 15,
        ),
        if (_tennisPlayerStore.index <
            _tennisPlayerStore.tennisPlayersSummary!.length - 1)
          InkWell(
            onTap: () async {
              _tennisPlayerStore.nextTennisPlayer();
            },
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.getColors(context).tennisPlayerDetailsTitleColor,
            ),
          ),
      ],
    );
  }
}
