import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/controllers/common_controller.dart';

import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/chose_image_source.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/loading_button.dart';
import 'package:sharing_map/utils/compress_image.dart';
import 'package:sharing_map/widgets/need_registration.dart';
import 'package:sharing_map/widgets/no_contacts_button.dart';

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
  UserController _userController = Get.find<UserController>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void selectImages() async {
    var source = await chooseImageSource(context, "Выберите изображения");
    if (source == null) {
      return;
    }
    List<XFile> selectedImages = [];
    if (source == ImageSource.gallery) {
      selectedImages = await imagePicker.pickMultiImage(imageQuality: 90);
    } else {
      var image = await imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        selectedImages.add(image);
      }
    }
    for (int i = 0; i < selectedImages.length; i++) {
      selectedImages[i] = await compressImage(selectedImages[i], 256 * 1024);
    }
    if (selectedImages.isNotEmpty) {
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
  final dropDownKeyLocation = GlobalKey<DropdownSearchState<SMLocation>>();
  final dropDownKeyCategory = GlobalKey<DropdownSearchState<ItemCategory>>();

  void clearData() {
    dropDownKeyLocation.currentState?.clear();
    dropDownKeyCategory.currentState?.clear();
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
            ? Obx(() => _userController.myContacts.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(child: NoContactButton()))
                : Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          getTextField(titleController, 'Что вы хотите отдать',
                              (String? value) {
                            if (value?.isEmpty ?? true) {
                              return null;
                            }
                            if ((value?.length ?? 0) < 2) {
                              return "Пожалуйста, введите больше символов";
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
                            if (value?.length == 0) {
                              return null;
                            }
                            return null;
                          }, maxLines: 5, minLines: 3),
                          SizedBox(
                            height: 20,
                          ),
                          DropdownSearch<ItemCategory>.multiSelection(
                            key: dropDownKeyCategory,
                            autoValidateMode: AutovalidateMode.disabled,
                            validator: (value) {
                              if (value == null) {
                                return "Пожалуйста, выберите категорию";
                              }
                              var chosen = value;
                              if (chosen.isEmpty) {
                                return "Пожалуйста, выберите категорию";
                              }
                              if (chosen.length > 2) {
                                return "Пожалуйста, выберите не больше двух категорий";
                              }
                              return null;
                            },
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
                                    ? "Выберите до двух категорий"
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
                            key: dropDownKeyLocation,
                            autoValidateMode: AutovalidateMode.disabled,
                            validator: (value) {
                              if (value == null) {
                                return "Пожалуйста, выберите станцию метро";
                              }
                              var chosen = value;
                              if (chosen.isEmpty) {
                                return "Пожалуйста, выберите станцию метро";
                              }
                              if (chosen.length > 3) {
                                return "Пожалуйста, выберите не больше трёх станций метро";
                              }
                              return null;
                            },
                            onChanged: (List<SMLocation>? data) {
                              setState(() {
                                _chosenLocations = data ?? [];
                              });
                            },
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              baseStyle: getMediumTextStyle(),
                              dropdownSearchDecoration: InputDecoration(
                                labelText: _chosenLocations.length == 0
                                    ? "Выберите до трёх станций метро"
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
                            padding: const EdgeInsets.only(
                                top: 10, left: 20, right: 20),
                            child: LoadingButton("Опубликовать", () async {
                              await checkItem();
                            },
                                color: MColors.darkGreen,
                                textStyle: getBigTextStyle()
                                    .copyWith(color: MColors.white)),
                          ),
                        ]),
                      ),
                    )))
            : NeedRegistration());
  }

  Widget _getImageChoiceWidget() {
    return Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            getButton(context, "Добавьте до 5 фото", () {
              selectImages();
            }, textStyle: getMediumTextStyle()),
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

  Future<void> checkItem() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      showErrorScaffold(context, "Не получилось :(");
      return;
    }
    if (imageFileList?.isEmpty ?? false) {
      showErrorScaffold(context, "Добавьте, пожалуйста фото");
      return;
    }
    if ((imageFileList?.length ?? 0) > 5) {
      showErrorScaffold(context, "Очень много фотографий");
      return;
    }
    if (_userController.myContacts.isEmpty) {
      showErrorScaffold(
          context, "Пожалуйста, укажите хотя бы один контакт в профиле");
      return;
    }
    if (SharedPrefs().chosenCity == -1) {
      showErrorScaffold(context,
          "Не получилось. Кажется нужно обновить приложение или написать нам");
      return;
    }
    var item = Item("SOME_ID", titleController.text, descriptionController.text,
        SharedPrefs().chosenCity, SharedPrefs().userId,
        locationIds: _chosenLocations.map((e) => e.id).toList(),
        categoryIds: _chosenCategories.map((e) => e.id).toList(),
        subcategoryId: 1,
        downloadableImages: imageFileList);

    if (!await _itemsController.addItem(item)) {
      showErrorScaffold(context, "Не получилось :(");
    } else {
      GoRouter.of(context).go(SMPath.home);
      clearData();
      setState(() {});
    }
  }
}
