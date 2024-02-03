import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/user/page/editable_contact_text_field.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/image.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<EditProfilePage> {
  // User _currentUser;
  ImagePicker imagePicker = ImagePicker();
  XFile? profileImage;
  UserController _userController = Get.find<UserController>();

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  void selectImage() async {
    var source = await _dialogBuilder(context);
    profileImage = await imagePicker.pickImage(source: source);
    if (profileImage == null) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: context.theme.primaryColor,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: _userController.GetMyself(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              User user = snapshot.data as User;
              _userNameController.text = user.username;
              _bioController.text = user.bio;
              return ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Center(
                      child: Stack(
                    children: [
                      Container(
                        width: 200.0,
                        height: 200.0,
                        // decoration: BoxDecoration(shape: BoxShape.circle),
                        child: InkWell(
                          onTap: () async {
                            selectImage();
                          },
                          child: CircleAvatar(
                              child: profileImage != null
                                  ? Image.file(File(profileImage!.path),
                                      fit: BoxFit.cover)
                                  : user.buildImage()),
                        ),
                      ),
                      Positioned(
                        top: 3,
                        right: 3,
                        child: IconButton(
                            onPressed: () async {
                              selectImage();
                            },
                            icon: Icon(Icons.edit)),
                      )
                    ],
                  )),
                  buildForm(user),
                ],
              );
            }));
  }

  Future<ImageSource> _dialogBuilder(BuildContext context) async {
    ImageSource _chosenSource = ImageSource.gallery;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы можете выбрать одно изображение'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Камера'),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Галерея'),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ],
        );
      },
    );
    return _chosenSource;
  }

  Widget buildForm(User user) {
    return Container(
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
              controller: _userNameController,
              decoration: const InputDecoration(
                label: Text('Имя'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextField(
            autofocus: true,
            controller: _bioController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              label: Text('Расскажи о себе'),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отменить'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var user = User(
                      id: SharedPrefs().userId,
                      username: _userNameController.text,
                      bio: _bioController.text);

                  var result =
                      await _userController.UpdateUser(user, profileImage);
                  if (result) {
                    Navigator.of(context).maybePop();
                  }
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email!,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'О себе',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.bio,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
