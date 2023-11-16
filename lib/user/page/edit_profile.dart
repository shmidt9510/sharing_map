
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/user/widgets/profile.dart';
import 'package:sharing_map/utils/shared.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<EditProfilePage> {
  // User _currentUser;
  ImagePicker imagePicker = ImagePicker();
  XFile? profileImage;
  ImageSource _imageSource = ImageSource.gallery;
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: _userController.GetMyself(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              User user = snapshot.data as User;
              _userNameController.text = user.username;
              _bioController.text = user.bio;
              return ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Center(
                      child: ProfileWidget(
                    user: user,
                    onClicked: () async {
                      selectImage();
                    },
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Галерея'),
              onPressed: () {
                Navigator.of(context).pop();
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
            height: 20,
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
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Добавить'),
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
}
