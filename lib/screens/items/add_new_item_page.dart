import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/controllers/common_controller.dart';

import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/allWidgets.dart';

enum PhotoSource { FILE, NETWORK }

const List<String> itemType = <String>['Отдам', 'Возьму'];

class AddNewItemPage extends StatefulWidget {
  @override
  _AddNewItemPageState createState() => _AddNewItemPageState();
}

class _AddNewItemPageState extends State<AddNewItemPage> {
  ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  ItemController _itemsController = Get.find<ItemController>();
  CommonController _commonController = Get.find<CommonController>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  // final FocusNode _focusNodeText = FocusNode();
  List<SMLocation> _chosenLocations = [];
  List<ItemCategory> _chosenCategories = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String dropdownValue = itemType.first;

  void clearData() {
    _chosenLocations.clear();
    _chosenCategories.clear();
    titleController.clear();
    descriptionController.clear();
    dropdownValue = "";
    imageFileList?.clear();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Создать объявление")),
        body: SharedPrefs().logged
            ? Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      getTextField(titleController, 'Что вы хотите отдать',
                          (String? value) {
                        if ((value?.length ?? 0) < 2) {
                          return "Пожалуйста введите больше символов";
                        }
                        if ((value?.startsWith(" ") ?? false)) {
                          return "Название не должно начинаться с пробела";
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      getTextField(descriptionController, 'Описание',
                          (String? value) {
                        return (value?.length ?? 0) > 16
                            ? null
                            : "Пожалуйста сделайте описание чуть подробнее";
                      }, maxLines: 5, minLines: 3),
                      SizedBox(
                        height: 20,
                      ),
                      DropdownSearch<ItemCategory>.multiSelection(
                        validator: (value) =>
                            value == null ? 'Выберите категорию' : null,
                        onChanged: (List<ItemCategory>? data) {
                          setState(() {
                            _chosenCategories = data ?? [];
                          });
                        },
                        itemAsString: (ItemCategory u) => u.description,
                        filterFn: ((item, filter) {
                          return item.id != 0;
                        }),
                        items: _commonController.categories,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          baseStyle: getMediumTextStyle(),
                          dropdownSearchDecoration: InputDecoration(
                            labelText: _chosenCategories.length == 0
                                ? " Выберите категорию"
                                : "",
                            hintStyle: getMediumTextStyle(),
                            labelStyle: getMediumTextStyle(),
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MColors.secondaryGreen),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: false,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<SMLocation>.multiSelection(
                        validator: (value) =>
                            value == null ? 'field required' : null,
                        onChanged: (List<SMLocation>? data) {
                          setState(() {
                            _chosenLocations = data ?? [];
                          });
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          baseStyle: getMediumTextStyle(),
                          dropdownSearchDecoration: InputDecoration(
                            labelText: _chosenLocations.length == 0
                                ? " Выберите метро"
                                : "",
                            hintStyle: getMediumTextStyle(),
                            labelStyle: getMediumTextStyle(),
                            filled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: MColors.secondaryGreen),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        items: _commonController.locations,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSearchBox: true,
                        ),
                      ),
                      _getImageChoiceWidget(),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: getButton(context, "Опубликовать", () async {
                          if (!(_formKey.currentState?.validate() ?? false)) {
                            showErrorScaffold(context, "Не получилось :(");
                            return;
                          }
                          if (imageFileList?.isEmpty ?? false) {
                            showErrorScaffold(
                                context, "Добавьте пожалуйста фото");
                            return;
                          }
                          if ((imageFileList?.length ?? 0) > 5) {
                            showErrorScaffold(
                                context, "Очень много фотографий");
                            return;
                          }
                          var item = Item(
                              "SOME_ID",
                              titleController.text,
                              descriptionController.text,
                              1,
                              SharedPrefs().userId,
                              locationIds:
                                  _chosenLocations.map((e) => e.id).toList(),
                              categoryIds: _chosenCategories
                                  .map((e) => e.id ?? 0)
                                  .toList(),
                              subcategoryId: 1,
                              downloadableImages: imageFileList);

                          if (await _itemsController.addItem(item)) {
                            clearData();
                            await _itemsController.fetchItems();
                            setState(() {});
                            GoRouter.of(context).go(SMPath.home);
                          } else {
                            showErrorScaffold(context, "Не получилось :(");
                          }
                        },
                            color: MColors.darkGreen,
                            textStyle: getBigTextStyle()
                                .copyWith(color: MColors.white)),
                      ),
                    ]),
                  ),
                ))
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(children: [
                  Text("Чтобы редактировать профиль надо зарегестрироваться"),
                  SizedBox(
                    height: 10,
                  ),
                  getButton(context, "Регистрируемся?", () {
                    GoRouter.of(context)
                        .go(SMPath.start + "/" + SMPath.registration);
                  })
                ]),
              ));
  }

  Widget _getImageChoiceWidget() {
    return Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            getButton(context, "Добавьте до 5 фото", () {
              selectImages();
            }, textStyle: getBigTextStyle()),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: ((imageFileList!.length) ~/ 4 +
                        (imageFileList!.isEmpty ? 0 : 1)) *
                    (context.width / 3 - 20),
                child: imageFileList!.length > 0
                    ? GridView.builder(
                        shrinkWrap: false,
                        physics: ScrollPhysics(),
                        itemCount: imageFileList!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: (context.width / 3 - 20),
                            child: Stack(fit: StackFit.expand, children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Image.file(
                                    File(imageFileList![index].path),
                                    fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 3,
                                right: 3,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      imageFileList!.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: MColors.red1,
                                  ),
                                ),
                              ),
                            ]),
                          );
                        })
                    : Container(),
              ),
            )
          ],
        ));
  }
}
