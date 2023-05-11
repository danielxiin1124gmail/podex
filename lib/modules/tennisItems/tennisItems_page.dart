import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/shared/models/tennisItem.dart';
import 'package:pokedex/shared/stores/tennisItem_store/tennisItem_store.dart';
import 'package:pokedex/shared/utils/image_utils.dart';

class TennisItemsPage extends StatefulWidget {
  // 他是statefulWidget 多半是因为搜索功能。一但输入文字、onChange，立即更新结果页面。
  const TennisItemsPage({Key? key}) : super(key: key);

  @override
  State<TennisItemsPage> createState() => _TennisItemsPageState();
}

class _TennisItemsPageState extends State<TennisItemsPage> {
  static const _pageSize = 20;

  final TennisItemStore _tennisItemStore = GetIt.instance<TennisItemStore>();
  // 相比于 pokemon_grid_page.dart，上面这行本页多了final。

  final PagingController<int, Widget> _pagingController =
      PagingController(firstPageKey: 0);
  // 首先，PagingController 主要是按需fetch data，一次就fetch 20来个，节省资源。
  // 其次，firstPageKey: 必须为0，不然会跳过前面n个物品。

  late ReactionDisposer filterReactionDisposer;

  @override
  void initState() {
    _fetchTennisItems();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchTennisItemPage(pageKey);
    });

    filterReactionDisposer = reaction((_) => _tennisItemStore.filter, (_) {
      _pagingController.refresh();
    });

    super.initState(); // 经测试，这个其实可以摆在最上面，一切正常。
  }

  Future<void> _fetchTennisItems() async {
    await _tennisItemStore.fetchTennisItems();
    // 这就是fetch所有物品，去掉会无法读取物品，一直转圈圈。
  }

  double getTennisItemsPagePadding(Size size) {
    double horizontalPadding = 0;

    if (size.width > 1200) {
      horizontalPadding = size.width * 0.15;
    } else {
      horizontalPadding = 10;
    }

    return horizontalPadding;
  }

  void _fetchTennisItemPage(int pageKey) async {
    final maxRange = _tennisItemStore.tennisItems.length;
    final initialRange = pageKey * _pageSize;
    final finalRange = (pageKey * _pageSize) + _pageSize > maxRange
        ? maxRange
        : (pageKey * _pageSize) + _pageSize;
    //print('<items_page.dart> maxRange = $maxRange');
    //print('<items_page.dart> initialRange = $initialRange');
    //print('<items_page.dart> finalRange = $finalRange');

    List<Widget> tennisItems = [];

    for (int index = initialRange; index < finalRange; index++) {
      final _tennisItem = _tennisItemStore.tennisItems[index];

      tennisItems.add(await _buildTennisItemWidget(tennisItem: _tennisItem));
    }

    if (maxRange == finalRange) {
      _pagingController.appendLastPage(tennisItems);
    } else {
      _pagingController.appendPage(tennisItems, pageKey + 1);
    }
  }

  // 下面是 item页面的每个item的设计代码。
  Future<ListTile> _buildTennisItemWidget({required TennisItem tennisItem}) {
    return Future.delayed(Duration.zero, () {
      final TextTheme textTheme = Theme.of(context).textTheme;

      return ListTile(
        leading: tennisItem.imageUrl != null
            ? ImageUtils.networkImage(
                url: tennisItem.imageUrl!,
                height: 25,
                width: 25,
              )
            : Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 20,
              ),
        title: Text(
          tennisItem.name,
          style: textTheme.bodyLarge,
        ),
        trailing: Text(
          tennisItem.category,
          style: textTheme.bodyLarge,
        ),
        /*subtitle: tennisItem.effect.trim().length > 0
            ? Text(
          tennisItem.effect,
                style: textTheme.titleMedium,
              )
            : null,*/
        // 上面的item.effect.trim().length > 0，表示减去空白之后，是否字数>0；即，
        // 除了空白以外，有无文字。有，那就显示，没有，那就null。
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // print('<items_page.dart> size = $size');
    // 我的emulator是 size = Size(411.4, 867.4)。拉大或缩小视窗，并不影响数值。

    return Observer(builder: (_) {
      // pokemon_grid_page.dart 的这地方，一开始也是 return Observer。
      if (_tennisItemStore.tennisItems.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: getTennisItemsPagePadding(size),
          ),
          sliver: PagedSliverList.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Widget>(
              itemBuilder: (context, item, index) => item,
            ),
            separatorBuilder: (context, index) {
              return Divider();
              // 这是两个物品之间的分隔线。
            },
          ),
        );
      }
    });
  }
}
