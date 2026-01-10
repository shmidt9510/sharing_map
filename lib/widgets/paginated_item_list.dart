import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/screens/items/item_actions.dart';
import 'package:sharing_map/screens/items/item_detail_page.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/item_give_block.dart';
import 'package:sharing_map/widgets/item_get_block.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum ItemListType {
  give,
  get,
  selfProfile,
  otherProfile,
}

class PaginatedItemList extends StatefulWidget {
  final PagingController<int, Item> pagingController;
  final ItemListType listType;
  final bool useGoRouter;
  final bool shouldDisposeController;

  const PaginatedItemList({
    Key? key,
    required this.pagingController,
    required this.listType,
    this.useGoRouter = true,
    this.shouldDisposeController = false,
  }) : super(key: key);

  @override
  State<PaginatedItemList> createState() => _PaginatedItemListState();
}

class _PaginatedItemListState extends State<PaginatedItemList> {
  @override
  Widget build(BuildContext context) {
    return PagingListener<int, Item>(
      controller: widget.pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedListView<int, Item>.separated(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate<Item>(
            firstPageErrorIndicatorBuilder: (_) => _buildErrorIndicator(),
            newPageErrorIndicatorBuilder: (_) => _buildErrorIndicator(),
            noItemsFoundIndicatorBuilder: (_) => _buildNoItemsIndicator(),
            animateTransitions: true,
            itemBuilder: (context, item, index) => _buildItemWidget(item),
          ),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
        );
      },
    );
  }

  @override
  void dispose() {
    // Only dispose if we own this controller
    if (widget.shouldDisposeController) {
      widget.pagingController.dispose();
    }
    super.dispose();
  }

  Widget _buildErrorIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_sharp, color: MColors.red1, size: 48),
          const SizedBox(height: 8),
          const Text("Ошибка, попробуйте обновить позднее"),
        ],
      ),
    );
  }

  Widget _buildNoItemsIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/no_data_placeholder.png'),
          const SizedBox(height: 8),
          const Text("Здесь пока ничего нет"),
        ],
      ),
    );
  }

  Widget _buildItemWidget(Item item) {
    return InkWell(
      onTap: () => _navigateToDetail(item.id),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: _buildItemContent(item),
      ),
    );
  }

  Widget _buildItemContent(Item item) {
    Widget baseWidget;

    switch (widget.listType) {
      case ItemListType.get:
        baseWidget = ItemGetBlock(item);
        break;
      case ItemListType.give:
      case ItemListType.selfProfile:
      case ItemListType.otherProfile:
        baseWidget = ItemGiveBlock(item);
        break;
    }

    if (widget.listType == ItemListType.selfProfile) {
      return Stack(
        children: [
          baseWidget,
          Positioned(
            top: 3,
            right: 3,
            child: ItemActionsWidget(item),
          ),
          Positioned(
            top: 5,
            left: 6,
            child: Container(
              alignment: Alignment.center,
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: MColors.darkGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.subcategoryId == 1 ? "Отдаю" : "Ищу",
                style: TextStyle(
                  color: MColors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return baseWidget;
  }

  void _navigateToDetail(String itemId) {
    if (widget.useGoRouter) {
      GoRouter.of(context).go("${SMPath.home}/item/$itemId");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetailPage(itemId),
        ),
      );
    }
  }
}
