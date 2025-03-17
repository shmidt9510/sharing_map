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
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/chose_image_source.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/utils/compress_image.dart';
import 'package:sharing_map/widgets/need_registration.dart';
import 'package:sharing_map/widgets/no_contacts_button.dart';
import 'package:sharing_map/utils/texts.dart';

enum PhotoSource { FILE, NETWORK }

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
  PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool _isLoading = false;
  int _subcategoryId = 1;

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
  final dropDownKeyLocation = GlobalKey<DropdownSearchState<SMLocation>>();
  final dropDownKeyCategory = GlobalKey<DropdownSearchState<ItemCategory>>();

  void clearData() {
    dropDownKeyLocation.currentState?.clear();
    dropDownKeyCategory.currentState?.clear();
    _chosenLocations.clear();
    _chosenCategories.clear();
    titleController.clear();
    descriptionController.clear();
    imageFileList?.clear();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Создать объявление")),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SharedPrefs().logged
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      height: context.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          Flexible(
                            flex: 1,
                            child: _selectedIndex > 0
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: MColors
                                          .green, // Background color of the button
                                      shape: BoxShape.circle, // Circular shape
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: MColors.white,
                                        weight: 1200,
                                      ),
                                      onPressed: () {
                                        if (_selectedIndex > 0) {
                                          _pageController.previousPage(
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                        }
                                        setState(() {});
                                      },
                                    ))
                                : Container(),
                          ),
                          Spacer(flex: 5),
                          Flexible(
                            flex: 1,
                            child: _selectedIndex > 0
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: MColors
                                          .green, // Background color of the button
                                      shape: BoxShape.circle, // Circular shape
                                    ),
                                    child: _pageController.hasClients &&
                                            (_pageController.page ?? 0) == 4
                                        ? IconButton(
                                            onPressed: _isLoading
                                                ? null
                                                : () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    try {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        if (!await checkItem()) {
                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                        }
                                                      }
                                                    } catch (e) {
                                                      debugPrint("catch " +
                                                          e.toString());
                                                    }
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    await Future.delayed(
                                                        Duration(
                                                            microseconds: 100));
                                                    _pageController
                                                        .jumpToPage(0);
                                                  },
                                            icon: _isLoading
                                                ? CircularProgressIndicator
                                                    .adaptive()
                                                : Icon(
                                                    Icons.check_rounded,
                                                    color: MColors.white,
                                                    weight: 1200,
                                                  ))
                                        : IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_rounded,
                                              color: MColors.white,
                                              weight: 1200,
                                            ),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                _pageController.nextPage(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease,
                                                );
                                              }
                                              setState(() {});
                                            }),
                                  )
                                : Container(),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 10,
                  )),
        body: SharedPrefs().logged
            ? Obx(
                () => _userController.myContacts.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(child: NoContactButton()))
                    : Form(
                        key: _formKey,
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            _getItemTypeWidget(),
                            _getNameAndDescription(),
                            _getCategoryWidget(),
                            _getSubwayWidget(),
                            _getImageChoiceWidget(),
                          ],
                        ),
                      ),
              )
            : NeedRegistration());
  }

  Widget _getItemTypeWidget() {
    return Container(
      height: context.height * 0.35,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            Flexible(
              flex: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _subcategoryId = 1;
                  });
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: Container(
                    child: Row(
                      children: [
                        Spacer(
                          flex: 3,
                        ),
                        Text(
                          "Отдать",
                          style: getMediumTextStyle(color: MColors.white),
                        ),
                        Spacer(
                          flex: 6,
                        ),
                        Flexible(
                            flex: 10,
                            child: Image.asset('assets/images/give_icon.png')),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: MColors.green,
                          width: 0.0,
                        ),
                        color: MColors.green)),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 10,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _subcategoryId = 2;
                  });
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                child: Container(
                    child: Row(
                      children: [
                        Spacer(flex: 3),
                        Text("Взять",
                            style: getMediumTextStyle(color: MColors.white)),
                        Spacer(
                          flex: 6,
                        ),
                        Flexible(
                            flex: 10,
                            child: Image.asset('assets/images/take_icon.png')),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: MColors.darkGreen)),
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getNameAndDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getTextField(titleController, hintForName[_subcategoryId - 1],
              (String? value) {
            if (value?.isEmpty ?? true) {
              return "Название не должно быть пустым";
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
          getTextField(descriptionController, 'Описание', (String? value) {
            if (value?.length == 0) {
              return null;
            }
            return null;
          }, maxLines: 5, minLines: 3),
          Spacer(),
          Flexible(
            flex: 4,
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Center(
                  child: Text(
                hintForRule[_subcategoryId - 1],
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                textAlign: TextAlign.center,
                style: getBigTextStyle(),
              )),
            ),
          ),
          // Spacer(),
        ],
      ),
    );
  }

  Widget _getImageChoiceWidget() {
    return FormField<int>(validator: (value) {
      if (imageFileList?.isEmpty ?? true) {
        return "Пожалуйста, добавьте хотя бы одно фото";
      }
      return null;
    }, builder: (FormFieldState<int> state) {
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
                      (context.width / 3 - 20) *
                      1.05,
                  child: imageFileList!.length > 0
                      ? GridView.builder(
                          // shrinkWrap: false,
                          physics: ScrollPhysics(),
                          itemCount: imageFileList!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            double borderWidth = 3;
                            double borderRadius = 20;
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: MColors.transparent,
                                  width: borderWidth,
                                ),
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                              width: (context.width / 3 - 20),
                              child: Stack(fit: StackFit.expand, children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          borderRadius - borderWidth),
                                    ),
                                    child: Image.file(
                                        File(imageFileList![index].path),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        imageFileList!.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: MColors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        size: 14,
                                        Icons.delete,
                                        color: MColors.grey2,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            );
                          })
                      : Container(),
                ),
              ),
              if (state.hasError)
                Text(
                  state.errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                )
            ],
          ));
    });
  }

  Widget _getCategoryWidget() {
    return FormField<List<ItemCategory>>(validator: (value) {
      if ((value?.length ?? 0) == 0 && _chosenCategories.isEmpty) {
        return "Пожалуйста выберите категорию";
      }
      return null;
    }, builder: (FormFieldState<List<ItemCategory>> state) {
      return Column(children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Выберите до двух категорий",
          style: getMediumTextStyle(),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0, // gap between adjacent chips
              children: _commonController.categories.sublist(1).map((item) {
                final isSelected = _chosenCategories.contains(item);
                return ChoiceChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              color: _chosenCategories.contains(item)
                                  ? MColors.lightGreen
                                  : MColors.inputField,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: _commonController
                                    .chooseCategorieImage(item),
                                fit: BoxFit.fitHeight,
                              ),
                              border: Border.all(
                                color: _chosenCategories.contains(item)
                                    ? MColors.green
                                    : MColors.inputField,
                                width: 2.0,
                              )),
                          child: Container()),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        item.description,
                        style: getMediumTextStyle(),
                      ),
                    ],
                  ),
                  selectedColor: MColors.green,
                  onSelected: (selected) {
                    setState(() {
                      if (_chosenCategories.length < 2 ||
                          _chosenCategories.contains(item)) {
                        if (selected) {
                          _chosenCategories.add(item);
                        } else {
                          _chosenCategories.remove(item);
                        }
                        state.didChange(_chosenCategories);
                      } else {
                        null;
                      }
                    });
                  },
                );
              }).toList(),
            )),
        if (state.hasError)
          Text(
            state.errorText!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          )
      ]);
    });
  }

  Widget _getSubwayWidget() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(hintForLocation[_subcategoryId - 1]),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: DropdownSearch<SMLocation>.multiSelection(
            key: dropDownKeyLocation,
            autoValidateMode: AutovalidateMode.disabled,
            validator: (value) {
              if (value == null) {
                return "Пожалуйста, выберите локации";
              }
              var chosen = value;
              if (chosen.isEmpty) {
                return "Пожалуйста, выберите локации";
              }
              if (chosen.length > 3) {
                return "Пожалуйста, выберите не больше трёх локаций";
              }
              return null;
            },
            onChanged: (List<SMLocation>? data) {
              setState(() {
                _chosenLocations = data ?? [];
              });
            },
            popupProps: PopupPropsMultiSelection.bottomSheet(
              emptyBuilder: (context, searchEntry) => Center(
                  child: Text('Пусто', style: TextStyle(color: Colors.blue))),
              showSearchBox: true,
              bottomSheetProps: BottomSheetProps(
                  backgroundColor: MColors.white,
                  constraints: BoxConstraints(maxWidth: context.width * 0.9)),
              searchDelay: Duration(milliseconds: 10),
              itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: context.width * 0.7,
                  height: context.height * 0.07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 8,
                        child: Text(
                          item.name,
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Spacer(flex: 1),
                      Flexible(flex: 1, child: item.getLocationIcon)
                    ],
                  ),
                ),
              ),
            ),
            decoratorProps: DropDownDecoratorProps(
              baseStyle: getMediumTextStyle(),
              decoration: InputDecoration(
                labelText: _chosenLocations.length == 0
                    ? "Выберите до трёх локаций"
                    : "",
                hintStyle: getMediumTextStyle(),
                labelStyle: getMediumTextStyle(),
                filled: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MColors.secondaryGreen),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            compareFn: (item1, item2) => item1.name == item2.name,
            items: (f, cs) => _commonController.locations,
          ),
        )
      ],
    );
  }

  Future<bool> checkItem() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      showErrorScaffold(context, "Не получилось :(");
      return false;
    }
    if (imageFileList?.isEmpty ?? false) {
      showErrorScaffold(context, "Добавьте, пожалуйста фото");
      return false;
    }
    if ((imageFileList?.length ?? 0) > 5) {
      showErrorScaffold(context, "Очень много фотографий");
      return false;
    }
    if (_userController.myContacts.isEmpty) {
      showErrorScaffold(
          context, "Пожалуйста, укажите хотя бы один контакт в профиле");
      return false;
    }
    if (SharedPrefs().chosenCity == -1) {
      showErrorScaffold(context,
          "Не получилось. Кажется нужно обновить приложение или написать нам");
      return false;
    }
    var item = Item("SOME_ID", titleController.text, descriptionController.text,
        SharedPrefs().chosenCity, SharedPrefs().userId,
        locationIds: _chosenLocations.map((e) => e.id).toList(),
        categoryIds: _chosenCategories.map((e) => e.id).toList(),
        subcategoryId: _subcategoryId,
        downloadableImages: imageFileList);
    var addResult = await _itemsController.addItem(item);
    if (!addResult) {
      showErrorScaffold(context, "Не получилось :(");
      return false;
    }
    clearData();
    if (mounted) {
      setState(() {});
    }
    GoRouter.of(context).go(SMPath.home);
    return true;
  }
}
