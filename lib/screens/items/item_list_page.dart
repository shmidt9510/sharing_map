import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/size_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/categories_button_widget.dart';
import 'package:sharing_map/widgets/top_icons.dart';

import 'item_widgets.dart';

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
                        Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          child: TopIcons(),
                          flex: 2,
                        ),
                        Expanded(
                          flex: 8,
                          child: Container(
                            height: height * 8,
                            padding:
                                EdgeInsets.only(top: padding, bottom: padding),
                            child: CategoriesButtonWidget(
                                (int id) => setState(() {
                                      _chosenFilter = id;
                                    }),
                                height * .7),
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
            child: ItemsListView(
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
