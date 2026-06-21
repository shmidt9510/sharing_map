import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/controllers/size_controller.dart';
import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/utils/colors.dart';

class CategoriesButtonWidget extends StatefulWidget {
  final double height;
  final Function(int) filterChanged;

  CategoriesButtonWidget(this.filterChanged, this.height);

  @override
  CategoriesButtonWidgetState createState() => CategoriesButtonWidgetState();
}

class CategoriesButtonWidgetState extends State<CategoriesButtonWidget> {
  CommonController _commonController = Get.find<CommonController>();
  SizeController _sizeController = Get.find<SizeController>();
  int _chosenFilter = 0;

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 100;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollOffset = context.width / 5;
    return Stack(children: [
      ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: _commonController.categories.length,
        itemBuilder: (BuildContext context, int index) => _buildButton(
            context, _commonController.categories[index], widget.height),
      ),
    ]);
  }

  Widget _buildButton(
      BuildContext context, ItemCategory category, double size) {
    bool isChosen = category.id == _chosenFilter;
    double imageSize = .7;
    double spaceSize = .03;
    double textSize = .27;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: size * imageSize,
              height: size * imageSize,
              decoration: BoxDecoration(
                  color: isChosen ? MColors.lightGreen : MColors.inputField,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _commonController.getCategoryImage(category),
                    fit: BoxFit.fitWidth,
                  ),
                  border: Border.all(
                    color: isChosen ? MColors.darkGreen : MColors.inputField,
                    width: 2.0, // Border width
                  )),
              child: InkWell(
                customBorder: const CircleBorder(),
                // splashFactory: NoSplash.splashFactory,
                onTap: () async {
                  setState(() {
                    _chosenFilter = category.id;
                    widget.filterChanged(category.id);
                  });
                },
              )),
          SizedBox(
            height: size * spaceSize,
          ),
          Container(
            // width: size * 0.9,
            height: size * textSize,
            child: Text(
              overflow: TextOverflow.visible,
              maxLines: 1,
              style: _sizeController.GetCategoryFont(),
              category.description,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
