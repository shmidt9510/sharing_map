import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/size_controller.dart';
import 'package:sharing_map/path.dart';

import 'package:sharing_map/screens/items/items_get_list.dart';
import 'package:sharing_map/screens/items/items_give_list.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/categories_button_widget.dart';
import 'package:sharing_map/widgets/top_icons.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/item_controller.dart';

class ItemListPage extends StatefulWidget {
  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  bool isLoading = false;
  ItemController _itemsController = Get.find<ItemController>();
  SizeController _sizeController = Get.find<SizeController>();

  int _chosenFilter = 0;
  int _itemType = 1;
  @override
  void initState() {
    super.initState();
    _chosenFilter = 0;
    _itemsController.refershAll();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = _sizeController.GetHeightOfBangs();
    double padding = 10.0;
    if (SharedPrefs().chosenCity == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).go(
          SMPath.chooseCity,
        );
      });
    }
    int iconsFlex = 2;
    int categoryFlex = 4;
    int flexSum = iconsFlex + categoryFlex;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MColors.white,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: MColors.transparent,
                  toolbarHeight: height,
                  title: SizedBox(
                    height: height,
                    child: Column(
                      children: [
                        Expanded(
                          child: TopIcons(
                            onItemTypeChange: (int type) => setState(() {
                              _itemType = type;
                            }),
                          ),
                          flex: iconsFlex,
                        ),
                        Expanded(
                          flex: categoryFlex,
                          child: Container(
                            height: categoryFlex * height / flexSum,
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: CategoriesButtonWidget(
                                (int id) => setState(() {
                                      _chosenFilter = id;
                                    }),
                                categoryFlex * height / flexSum -
                                    2.2 * padding),
                          ),
                        ),
                      ],
                    ),
                  ),
                  primary: false,
                  floating: true,
                  titleSpacing: 0,
                )
              ]),
          body: RefreshIndicator.adaptive(
            onRefresh: () {
              return _updateOnFetch();
            },
            child: (_itemType == 1)
                ? ItemsGiveListView(
                    itemFilter: _chosenFilter, key: ValueKey(_chosenFilter))
                : ItemsGetListView(
                    itemFilter: _chosenFilter, key: ValueKey(_chosenFilter)),
          ),
        ),
      ),
    );
  }

  Future<void> _updateOnFetch() async {
    _itemsController.refershAll();
  }
}
