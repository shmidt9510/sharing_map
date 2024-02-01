import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';

import 'item_widgets.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/screens/items/item_detail_page.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/widgets/item_block.dart';
import 'package:sharing_map/controllers/item_controller.dart';

class ItemListPage extends StatefulWidget {
  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  bool isLoading = false;
  CommonController _commonController = Get.find<CommonController>();
  ItemController _itemsController = Get.find<ItemController>();
  ScrollController _scrollController = ScrollController();
  int _chosenFilter = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = context.height * 0.22;
    double padding = 10.0;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MColors.white,
        body: RefreshIndicator(
          onRefresh: () {
            return _updateOnFetch();
          },
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    backgroundColor: MColors.transparent,
                    toolbarHeight: height,
                    title: SizedBox(
                      height: height,
                      child: Padding(
                        padding: EdgeInsets.only(top: padding, bottom: padding),
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _commonController.categories.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Card(
                            child: _buildButton(
                                context,
                                _commonController.categories[index],
                                height - padding * 2),
                          ),
                        ),
                      ),
                    ),
                    primary: false,
                    floating: true,
                    titleSpacing: 0,
                  )
                ]),
            body: ItemsListView(
                itemFilter: _chosenFilter, key: ValueKey(_chosenFilter)),
          ),
        ),
      ),
    );
  }

  Future<void> _updateOnFetch() async {
    await _itemsController.fetchItems(itemFilter: _chosenFilter);
    setState(() {
      _itemsController.fetchItems(itemFilter: _chosenFilter);
    });
  }

  var categoriesAssetsName = {
    0: 'all',
    1: 'home',
    2: 'books',
    3: 'clothes',
    4: 'child',
    5: 'pet',
    6: 'sport',
    7: 'appliance',
    8: 'food',
    9: 'auto',
    10: 'other',
  };

  Widget _buildButton(
      BuildContext context, ItemCategory category, double size) {
    bool isChosen = category.id == _chosenFilter;
    String assetName = "other";
    if (categoriesAssetsName.containsKey(category.id)) {
      assetName = categoriesAssetsName[category.id]!;
    }

    return AspectRatio(
      aspectRatio: 0.65,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // minimumSize: Size(10, 10),
            backgroundColor: isChosen ? MColors.lightGreen : MColors.inputField,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            _itemsController.pagingController.refresh();
            setState(() {
              _chosenFilter = category.id ?? 1;
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: size * 0.7 * 0.8,
                height: size * 0.7,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage("assets/images/categories/$assetName.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // SizedBox(
              //   height: size * 0.05,
              // ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      maxLines: 2,
                      style: getSmallTextStyle(),
                      category.description ?? "_",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
