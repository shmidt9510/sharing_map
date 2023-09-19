import 'models/item.dart';

import 'dart:io';

import 'widgets/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:sharing_map/items/list_page.dart';
import 'package:sharing_map/items/models/item.dart';
import 'package:sharing_map/items/item_block.dart';
import 'package:sharing_map/items/item_list_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:image_picker/image_picker.dart';

import 'package:sharing_map/items/controllers/item_controller.dart';
import 'package:get/get.dart';
import 'package:sharing_map/items/moEdels/item.dart';
import 'package:sharing_map/items/images/main_window.dart';

enum PhotoSource { FILE, NETWORK }

const List<String> itemType = <String>['Отдам', 'Возьму'];

class AddNewItemPage extends StatefulWidget {
  @override
  _AddNewItemPageState createState() => _AddNewItemPageState();
}

class _AddNewItemPageState extends State<AddNewItemPage> {
  ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String dropdownValue = itemType.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Создать объявление")),
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
                  autofocus: true,
                  controller: titleController,
                  decoration: const InputDecoration(
                    label: Text('Заголовок'),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              TextField(
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
              // SizedBox(width: 500.0, height: 300.0, child: ImagePickerWidget()),
              Container(
                  child: DropdownMenu<String>(
                initialSelection: itemType.first,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries:
                    itemType.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              )),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      MaterialButton(
                          color: Colors.blue,
                          child: const Text("Pick Images from Gallery",
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
                        child: SizedBox(
                          height: 400,
                          child: GridView.builder(
                              itemCount: imageFileList!.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                return Image.file(
                                    File(imageFileList![index].path),
                                    fit: BoxFit.cover);
                              }),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Item(this.id, this.name, this.desc, this.picture, this.creationDate);
                      // var item = Item(
                      //   id: titleController.text,
                      //   name: descriptionController.text,
                      //   desc: GUIDGen.generate(),
                      //   picture: dateController.text,
                      //   creationDat:
                      // ),
                      // context.read<TasksBloc>().add(AddTask(item: item));
                      // context
                      //     .read<TasksBloc>()
                      //     .add(GetTodayTasks(date: dateController.text));
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) {
                        return ItemListPage();
                      }));
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
