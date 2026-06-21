import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/controllers/common_controller.dart';

import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/address.dart';
import 'package:sharing_map/models/category.dart';
import 'package:sharing_map/models/item.dart';
import 'package:sharing_map/models/location.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/screens/items/add_new_item/bottom_nav_buttons.dart';
import 'package:sharing_map/screens/location_selection/location_selection_widget.dart';
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
  Address? _chosenAddress = null;
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
        body: SharedPrefs().logged
            ? Obx(
                () => _userController.myContacts.isEmpty
                    ? Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(child: NoContactButton()))
                    : Stack(
                        children: [
                          Form(
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
                                _getLocationWidget(),
                                _getImageChoiceWidget(),
                              ],
                            ),
                          ),
                          BottomNavButtons(
                              selectedIndex: _selectedIndex,
                              pageController: _pageController,
                              isLoading: _isLoading,
                              formKey: _formKey,
                              onSubmit: saveItem,
                              onStateChanged: () => setState(() {
                                    _isLoading = !_isLoading;
                                  }))
                        ],
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
                          "Хочу отдать",
                          style: getBigTextStyle(
                              color: MColors.white, fontSize: 20),
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
                        Text("Хочу взять",
                            style: getBigTextStyle(
                                color: MColors.white, fontSize: 20)),
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
          Spacer(),
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
                  height: ((imageFileList!.length + 2) ~/ 3) *
                      (context.width / 3 - 20) *
                      1.05,
                  child: imageFileList!.isNotEmpty
                      ? GridView.builder(
                          physics: const ScrollPhysics(),
                          itemCount: imageFileList!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                              child: Stack(fit: StackFit.expand, children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(borderRadius - borderWidth),
                                  ),
                                  child: Image.file(
                                    File(imageFileList![index].path),
                                    fit: BoxFit.cover, // ← was BoxFit.fill
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
                                      decoration: const BoxDecoration(
                                        color: MColors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
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
                                image: _commonController.getCategoryImage(item),
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

  Widget _getLocationWidget() {
    return LocationSelectionWidget(
      subcategoryId: _subcategoryId,
      chosenLocations: _chosenLocations,
      addresses: _userController.myAddresses,
      // chosenAddress: _chosenAddress,
      onLocationsChanged: (locations, address) {
        setState(() {
          _chosenLocations = locations;
          _chosenAddress = address;
        });
      },
      onAddressCreated: () {
        // this._chosenAddress
      },
    );
  }

  Future<bool> saveItem() async {
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
        downloadableImages: imageFileList,
        address: _chosenAddress);
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
