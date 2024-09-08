import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/loading_button.dart';

class EditProfileBioPage extends StatefulWidget {
  @override
  _EditProfileBioPageState createState() => _EditProfileBioPageState();

  EditProfileBioPage();
}

class _EditProfileBioPageState extends State<EditProfileBioPage> {
  TextEditingController _bioController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    var _user = _userController.myself;
    _bioController.text = _user.value.bio;
    _userNameController.text = _user.value.username;
    return Scaffold(
        appBar: AppBar(title: Text("Редактировать профиль")),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 40.0, bottom: 40, left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Имя",
                style: getBigTextStyle(),
              ),
              getTextField(
                _userNameController,
                maxLength: 50,
                "Ваше имя",
                (String? value) {
                  if (value?.isEmpty ?? false) {
                    return "Напишите ваше имя";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text("О себе", style: getBigTextStyle()),
              getTextField(
                maxLines: 20,
                maxLength: 1000,
                _bioController,
                "Расскажите про себя",
                (String? value) {
                  if (value?.isEmpty ?? false) {
                    return "Напишите что-нибудь";
                  }
                  return null;
                },
              ),
              Spacer(),
              LoadingButton("Сохранить", () async {
                if (_userNameController.text.isEmpty) {
                  showErrorScaffold(context, "Имя не должно быть пустым");
                }
                await saveUser(context);
                GoRouter.of(context).go(
                  SMPath.myItems + "/" + SMPath.profile,
                );
              })
            ],
          ),
        ));
  }

  Future<bool> saveUser(BuildContext context) async {
    var newUser = User(
        id: SharedPrefs().userId,
        username: _userNameController.text,
        bio: _bioController.text);

    if (!await _userController.UpdateUser(newUser)) {
      var snackBar = SnackBar(
        content: const Text('Ой :('),
        action: SnackBarAction(
          label: 'Закрыть',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {});
    return true;
  }
}
