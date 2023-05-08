import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';

import 'package:pokedex/modules/pokemon_details/pokemon_details.dart';
import 'package:pokedex/modules/tennisPlayer_details/tennisPlayer_details.dart';

import 'package:pokedex/modules/pokemon_grid/widgets/poke_item.dart';
import 'package:pokedex/modules/tennisPlayer_grid/widgets/tennisPlayer_item.dart';

import 'package:pokedex/shared/models/pokemon_summary.dart';
import 'package:pokedex/shared/models/tennisPlayer_summary.dart';

import 'package:pokedex/shared/stores/pokemon_store/pokemon_store.dart';
import 'package:pokedex/shared/stores/tennisPlayer_store/tennisPlayer_store.dart';

class TennisPlayerGridWidget extends StatefulWidget {
  final TennisPlayerStore tennisPlayerStore;

  TennisPlayerGridWidget({Key? key, required this.tennisPlayerStore})
      : super(key: key);

  @override
  _TennisPlayerGridWidgetState createState() => _TennisPlayerGridWidgetState();
}

class _TennisPlayerGridWidgetState extends State<TennisPlayerGridWidget> {
  static const _pageSize = 20;

  final PagingController<int, Widget> _pagingController =
      PagingController(firstPageKey: 0);

  late ReactionDisposer filterReactionDisposer;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
      _cacheNextPageImages(pageKey); // 这是预先载入下下页的缩图，减少延迟感。
    });

    // 下面这里，其实items的也有。MobX 的 reaction 会 一直 listen 着 pokemonStore 的 pokemonFilter 有无变化，
    // 一但有变化，就会触发 _pagingController.refresh()。
    filterReactionDisposer =
        reaction((_) => widget.tennisPlayerStore.tennisPlayerFilter, (_) {
      _pagingController.refresh();
    });

    super.initState();
  }

  @override
  void dispose() {
    filterReactionDisposer();

    super.dispose();
    // 当前不明白，为何这里有dispose，但是items_page.dart不用dispose。
  }

  void _fetchPage(int pageKey) async {
    final maxRange = widget.tennisPlayerStore.tennisPlayersSummary!.length;
    final initialRange = pageKey * _pageSize;
    final finalRange = (pageKey * _pageSize) + _pageSize > maxRange
        ? maxRange
        : (pageKey * _pageSize) + _pageSize;

    List<Widget> items = [];

    for (int index = initialRange; index < finalRange; index++) {
      final _tennisPlayer = widget.tennisPlayerStore.getTennisPlayer(index);

      items.add(
          _buildTennisPlayerItem(index: index, tennisPlayer: _tennisPlayer));

      _preCacheTennisPlayerImage(tennisPlayer: _tennisPlayer);
    }

    if (maxRange == finalRange) {
      _pagingController.appendLastPage(items);
    } else {
      _pagingController.appendPage(items, pageKey + 1);
    }
  }

  void _cacheNextPageImages(int nextPage) async {
    final maxPage =
        widget.tennisPlayerStore.tennisPlayersSummary!.length ~/ _pageSize;

    if (maxPage <= nextPage) {
      return;
    }

    final maxRange = widget.tennisPlayerStore.tennisPlayersSummary!.length;
    final initialRange = nextPage * _pageSize;
    final finalRange = (nextPage * _pageSize) + _pageSize > maxRange
        ? maxRange
        : (nextPage * _pageSize) + _pageSize;

    for (int index = initialRange; index < finalRange; index++) {
      final _tennisPlayer = widget.tennisPlayerStore.getTennisPlayer(index);

      precacheImage(Image.network(_tennisPlayer.thumbnailUrl).image, context);
    }
  }

  void _preCacheTennisPlayerImage({required TennisPlayerSummary tennisPlayer}) {
    if (kIsWeb) {
      precacheImage(Image.network(tennisPlayer.thumbnailUrl).image, context);
    } else {
      precacheImage(
          CachedNetworkImageProvider(tennisPlayer.thumbnailUrl), context);
    }
  }

  Widget _buildTennisPlayerItem(
      {required int index, required TennisPlayerSummary tennisPlayer}) {
    return InkWell(
      onTap: () async {
        await widget.tennisPlayerStore.setTennisPlayer(index);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return TennisPlayerDetailsPage();
          }),
        );
      },
      child: Ink(
        child: TennisPlayerItemWidget(
          tennisPlayer: tennisPlayer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid<int, Widget>(
      // items那页，用的是PagedSliverList。这里，用PagedSliverGrid，挺相似。
      showNewPageProgressIndicatorAsGridChild: false,
      showNewPageErrorIndicatorAsGridChild: false,
      showNoMoreItemsIndicatorAsGridChild: false,
      pagingController: _pagingController,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 3 / 2,
      ),
      builderDelegate: PagedChildBuilderDelegate<Widget>(
        itemBuilder: (context, item, index) => item,
      ),
    );
  }
}
