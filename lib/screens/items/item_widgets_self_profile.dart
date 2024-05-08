import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/screens/items/item_detail_page.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/item_block.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ItemsListViewSelfProfile extends StatefulWidget {
  const ItemsListViewSelfProfile({Key? key}) : super(key: key);

  @override
  _ItemsListViewSelfProfileState createState() =>
      _ItemsListViewSelfProfileState();
}

class _ItemsListViewSelfProfileState extends State<ItemsListViewSelfProfile> {
  ItemController _itemsController = Get.find<ItemController>();
  CommonController _commonController = Get.find<CommonController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => PagedListView<int, Item>.separated(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        pagingController: _itemsController.userPagingController,
        builderDelegate: PagedChildBuilderDelegate<Item>(
          firstPageErrorIndicatorBuilder: (_) => Center(
            child: Column(children: [
              Image.asset('assets/images/no_data_placeholder.png'),
            ]),
          ),
          newPageErrorIndicatorBuilder: (_) => Center(
            child: Column(children: [
              Image.asset('assets/images/no_data_placeholder.png'),
              Text("Здесь пока ничего нет")
            ]),
          ),
          noItemsFoundIndicatorBuilder: (_) => Center(
            child: Column(children: [
              Image.asset('assets/images/no_data_placeholder.png'),
              Text("Здесь пока ничего нет")
            ]),
          ),
          animateTransitions: true,
          itemBuilder: (context, item, index) => InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemDetailPage(item.id)));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Stack(
                  children: [
                    ItemBlock(item),
                    Positioned(
                      top: 3,
                      right: 3,
                      child: IconButton(
                          onPressed: () async {
                            if (item.cityId != SharedPrefs().chosenCity) {
                              var _chosenCity = _commonController.cities
                                  .firstWhere(
                                      (element) => element.id == item.cityId);
                              showErrorScaffold(context,
                                  "Чтобы менять объявления в городе ${_chosenCity.name}, пожалуйста переключитесь на него");
                            } else {
                              GoRouter.of(context)
                                  .go(SMPath.home + "/itemEdit/${item.id}");
                            }
                          },
                          icon: Icon(
                            Icons.edit,
                            color: MColors.darkGreen,
                          )),
                    ),
                    Positioned(
                      top: 3,
                      right: 40,
                      child: IconButton(
                          onPressed: () async {
                            await _deleteItemDialogBuilder(context, item.id);
                            setState(() {
                              _itemsController.userPagingController.refresh();
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: MColors.red1,
                          )),
                    ),
                  ],
                ),
              )),
        ),
        separatorBuilder: (context, index) => Container(
          height: 10,
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _deleteItemDialogBuilder(
      BuildContext context, String itemId) async {
    final ItemController _itemsController = Get.find<ItemController>();
    bool _result = false;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы точно хотите удалить объявление?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                _itemsController.deleteItem(itemId);
                _result = true;
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Нет'),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ],
        );
      },
    );
    return _result;
  }
}
