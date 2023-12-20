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
import 'package:sharing_map/utils/shared.dart';

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

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  final FocusNode _focusNodeText = FocusNode();
  List<SMLocation> _chosenLocations = [];
  List<ItemCategory> _chosenCategories = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String dropdownValue = itemType.first;

  @override
  Widget build(BuildContext context) {
    bool hasImages = imageFileList!.length > 0;
    return Scaffold(
        appBar: AppBar(title: Text("Создать объявление")),
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 10.0),
        //   child: FloatingActionButton.extended(
        //     onPressed: () {
        //       // Add your onPressed code here!
        //     },
        //     label: const Text('Добавить'),
        //     icon: const Icon(Icons.messenger_outline_outlined),
        //     backgroundColor: Colors.green,
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.,
        // зададим небольшие отступы для списка
        body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  focusNode: null,
                  autofocus: true,
                  controller: titleController,
                  decoration: const InputDecoration(
                    label: Text('Что вы хотите отдать'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              TextField(
                focusNode: _focusNodeText,
                autofocus: true,
                controller: descriptionController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  label: Text('Описание'),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownSearch<ItemCategory>.multiSelection(
                onChanged: (List<ItemCategory>? data) {
                  setState(() {
                    _chosenCategories = data ?? [];
                  });
                },
                itemAsString: (ItemCategory u) => u.description ?? "",
                filterFn: ((item, filter) {
                  return item.id != 0;
                }),
                items: _commonController.categories,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: _chosenCategories.length == 0
                        ? " Выберите категорию"
                        : "",
                    filled: false,
                  ),
                ),
                popupProps: PopupPropsMultiSelection.menu(
                  title: Text(" Выберите категории"),
                  showSearchBox: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownSearch<SMLocation>.multiSelection(
                onChanged: (List<SMLocation>? data) {
                  setState(() {
                    _chosenLocations = data ?? [];
                  });
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText:
                        _chosenLocations.length == 0 ? " Выберите метро" : "",
                    filled: false,
                  ),
                ),
                items: _commonController.locations,
                popupProps: PopupPropsMultiSelection.menu(
                  title: Text(" Выберите метро"),
                  showSearchBox: true,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      MaterialButton(
                          color: Colors.green,
                          child: const Text("Добавьте фото (не больше пяти)",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            selectImages();
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: (imageFileList!.length / 3 + 1) * 85,
                          child: hasImages
                              ? GridView.builder(
                                  physics: ScrollPhysics(),
                                  itemCount: imageFileList!.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Image.file(
                                                File(
                                                    imageFileList![index].path),
                                                fit: BoxFit.cover),
                                          ),
                                          Positioned(
                                            top: 3,
                                            right: 3,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  imageFileList!
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ]);
                                  })
                              : Container(),
                        ),
                      )
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).go(SMPath.home),
                    child: const Text('Отменить'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Item(this.id, this.name, this.desc, this.picture, this.creationDate);
                      var item = Item(
                          userId: SharedPrefs().userId,
                          name: titleController.text,
                          desc: descriptionController.text,
                          locationIds:
                              _chosenLocations.map((e) => e.id ?? 0).toList(),
                          cityId: 1,
                          categoryIds:
                              _chosenCategories.map((e) => e.id ?? 0).toList(),
                          subcategoryId: 1,
                          downloadableImages: imageFileList);
                      if (await _itemsController.addItem(item)) {
                        await _itemsController.fetchItems();
                        GoRouter.of(context).go(SMPath.home);
                      } else {
                        var snackBar = SnackBar(
                          content: const Text('Не получилось :('),
                          action: SnackBarAction(
                            label: 'Закрыть',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('Добавить'),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }

  @override
  void dispose() {
    _focusNodeText.dispose();
    super.dispose();
  }
}
