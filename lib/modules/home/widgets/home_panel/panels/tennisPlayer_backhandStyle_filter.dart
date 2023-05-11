import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/modules/home/home_page_store.dart';

import 'package:pokedex/modules/pokemon_grid/widgets/pokemon_type_item.dart';
import 'package:pokedex/modules/tennisPlayer_grid/widgets/tennisPlayer_backhandStyle_item.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

import 'package:pokedex/shared/utils/app_constants.dart';
import 'package:pokedex/theme/app_theme.dart';

class TennisPlayerBackhandStyleFilter extends StatelessWidget {
  static final TennisPlayerStore tennisPlayerStore =
      GetIt.instance<TennisPlayerStore>();

  final ScrollController scrollController;
  final HomePageStore homePageStore;

  const TennisPlayerBackhandStyleFilter(
      {Key? key, required this.homePageStore, required this.scrollController})
      : super(key: key);

  double get topPadding {
    if (tennisPlayerStore.tennisPlayerFilter.backhandStyleFilter != null) {
      return kIsWeb ? 68 : 50;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Observer(builder: (_) {
      return Padding(
        padding: const EdgeInsets.only(left: 28, right: 28, top: 28),
        child: Stack(
          children: [
            if (tennisPlayerStore.tennisPlayerFilter.backhandStyleFilter !=
                null)
              SizedBox(
                height: 40,
              ),
            Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [];
                },
                body: GridView.builder(
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 3 / 2,
                  ),
                  itemBuilder: (context, index) {
                    String backhandStyle =
                        AppConstants.tennisPlayerBackhandStyle[index];

                    Color? color;

                    if (tennisPlayerStore
                            .tennisPlayerFilter.backhandStyleFilter ==
                        null) {
                      color = AppTheme.getColors(context)
                          .tennisPlayerItem(backhandStyle);
                    } else {
                      color = tennisPlayerStore
                                  .tennisPlayerFilter.backhandStyleFilter ==
                              backhandStyle
                          ? AppTheme.getColors(context)
                              .tennisPlayerItem(backhandStyle)
                          : Colors.grey[400];
                    }

                    return TennisPlayerBackhandStyleItemWidget(
                      backhandStyle: backhandStyle,
                      color: color,
                      onClick: () {
                        if (tennisPlayerStore
                                    .tennisPlayerFilter.backhandStyleFilter !=
                                null &&
                            tennisPlayerStore
                                    .tennisPlayerFilter.backhandStyleFilter ==
                                backhandStyle) {
                          tennisPlayerStore.clearBackhandStyleFilter();
                        } else {
                          tennisPlayerStore
                              .addBackhandStyleFilter(backhandStyle);
                        }

                        homePageStore.closeFilter();
                      },
                    );
                  },
                  itemCount: AppConstants.tennisPlayerBackhandStyle.length,
                ),
              ),
            ),
            if (tennisPlayerStore.tennisPlayerFilter.backhandStyleFilter !=
                null)
              Container(
                height: 40,
                color: theme.colorScheme.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Click on the selected item to clear the filter",
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}
