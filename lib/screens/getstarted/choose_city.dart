import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/common_controller.dart';
import 'package:sharing_map/models/city.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/init_path.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/loading_button.dart';

class ChooseCitySreen extends StatefulWidget {
  @override
  ChooseCitySreenState createState() => ChooseCitySreenState();
}

class ChooseCitySreenState extends State<ChooseCitySreen> {
  int counter = 0;
  var _commonController = Get.find<CommonController>();
  late City dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = _commonController.cities.first;
  }

  @override
  Widget build(BuildContext context) {
    var cities = _commonController.cities;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: MColors.primaryGreen,
        child: Center(
          child: Column(
            children: [
              Spacer(flex: 4),
              SvgPicture.asset("assets/images/sharing_map_logo.svg",
                  height: 200),
              Spacer(flex: 2),
              Text("Выберите город",
                  style: getBigTextStyle()
                      .copyWith(color: MColors.white, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: MColors.white),
                child: SizedBox(
                  height: 50,
                  width: context.width * 0.5,
                  child: Center(
                    child: DropdownButton<City>(
                      icon: Icon(
                        FontAwesomeIcons.caretDown,
                        color: MColors.darkGreen,
                      ),
                      underline: Container(),
                      dropdownColor: MColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      value: dropdownValue,
                      onChanged: (City? newValue) {
                        setState(() {
                          dropdownValue =
                              newValue ?? City(-1, "Выберите город", null);
                        });
                      },
                      items: cities.map<DropdownMenuItem<City>>((City value) {
                        return DropdownMenuItem<City>(
                          value: value,
                          child: Container(
                              color: MColors.white,
                              child: Text(
                                value.name,
                                style: getMediumTextStyle()
                                    .copyWith(color: MColors.black),
                              )),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 2),
              SizedBox(
                width: context.width * 0.5,
                child: LoadingButton("Далее", () async {
                  SharedPrefs().chosenCity = dropdownValue.id;
                  await _commonController.getLocations(
                      SharedPrefs().chosenCity, true);
                  String _initPath = await checkInitPath();
                  GoRouter.of(context).go(_initPath);
                },
                    textStyle: getBigTextStyle()
                        .copyWith(color: MColors.white, fontSize: 20)),
              ),
              Spacer(flex: 4)
            ],
          ),
        ),
      ),
    );
  }
}
