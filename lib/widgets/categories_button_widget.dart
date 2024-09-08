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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _commonController.categories.length,
      itemBuilder: (BuildContext context, int index) => _buildButton(
          context, _commonController.categories[index], widget.height),
    );
  }

  Widget _buildButton(
      BuildContext context, ItemCategory category, double size) {
    bool isChosen = category.id == _chosenFilter;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: size * 0.7 * 0.8,
              height: size * 0.7 * 0.8,
              decoration: BoxDecoration(
                  color: isChosen ? MColors.lightGreen : MColors.inputField,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _commonController.chooseCategorieImage(category),
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
            width: size * 0.7 * 0.8,
            height: 10,
          ),
          Container(
            width: size * 0.7 * 0.8,
            height: 10 * 2,
            child: Text(
              maxLines: 2,
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
