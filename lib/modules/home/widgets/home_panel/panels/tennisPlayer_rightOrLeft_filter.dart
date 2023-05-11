import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/modules/home/home_page_store.dart';

import 'package:pokedex/modules/pokemon_grid/widgets/pokemon_type_item.dart';
import 'package:pokedex/modules/tennisPlayer_grid/widgets/tennisPlayer_rightOrLeft_item.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

import 'package:pokedex/shared/utils/app_constants.dart';
import 'package:pokedex/theme/app_theme.dart';

class TennisPlayerRightOrLeftFilter extends StatelessWidget {
  static final TennisPlayerStore tennisPlayerStore =
      GetIt.instance<TennisPlayerStore>();

  final ScrollController scrollController;
  final HomePageStore homePageStore;

  const TennisPlayerRightOrLeftFilter(
      {Key? key, required this.homePageStore, required this.scrollController})
      : super(key: key);

  double get topPadding {
    if (tennisPlayerStore.tennisPlayerFilter.rightOrLeftFilter != null) {
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
            if (tennisPlayerStore.tennisPlayerFilter.rightOrLeftFilter != null)
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
                    String rightOrLeft =
                        AppConstants.tennisPlayerRightOrLeft[index];

                    Color? color;

                    if (tennisPlayerStore
                            .tennisPlayerFilter.rightOrLeftFilter ==
                        null) {
                      color = AppTheme.getColors(context)
                          .tennisPlayerItem(rightOrLeft);
                    } else {
                      color = tennisPlayerStore
                                  .tennisPlayerFilter.rightOrLeftFilter ==
                              rightOrLeft
                          ? AppTheme.getColors(context)
                              .tennisPlayerItem(rightOrLeft)
                          : Colors.grey[400];
                    }

                    return TennisPlayerRightOrLeftItemWidget(
                      rightOrLeft: rightOrLeft,
                      color: color,
                      onClick: () {
                        if (tennisPlayerStore
                                    .tennisPlayerFilter.rightOrLeftFilter !=
                                null &&
                            tennisPlayerStore
                                    .tennisPlayerFilter.rightOrLeftFilter ==
                                rightOrLeft) {
                          tennisPlayerStore.clearRightOrLeftFilter();
                        } else {
                          tennisPlayerStore.addRightOrLeftFilter(rightOrLeft);
                        }

                        homePageStore.closeFilter();
                      },
                    );
                  },
                  itemCount: AppConstants.tennisPlayerRightOrLeft.length,
                ),
              ),
            ),
            if (tennisPlayerStore.tennisPlayerFilter.rightOrLeftFilter != null)
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
