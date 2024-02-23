import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/screens/items/item_widgets_self_profile.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/user/page/editable_contact_text_field.dart';
import 'package:sharing_map/utils/chose_image_source.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/compress_image.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/image.dart';
import 'package:sharing_map/widgets/editable_text.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController _userController = Get.find<UserController>();
  ImagePicker imagePicker = ImagePicker();
  XFile? profileImage;
  TextEditingController _bioController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var contacts = _userController.myContacts;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: MColors.secondaryGreen,
          onPressed: () => GoRouter.of(context).go(SMPath.home),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: SharedPrefs().logged ? _getActions(context) : null,
      ),
      body: FutureBuilder(
          future: _userController.GetMyself(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(children: [
                  Text("Чтобы редактировать профиль, надо зарегистрироваться"),
                  SizedBox(
                    height: 10,
                  ),
                  getButton(context, "Регистрация", () {
                    GoRouter.of(context)
                        .go(SMPath.start + "/" + SMPath.registration);
                  }, color: MColors.grey1),
                  SizedBox(
                    height: 10,
                  ),
                  getButton(context, "Войти", () {
                    GoRouter.of(context).go(SMPath.start + "/" + SMPath.login);
                  })
                ]),
              );
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            var _user = snapshot.data as User;
            _bioController.text = _user.bio;
            _userNameController.text = _user.username;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 2,
                            child: Stack(children: [
                              ClipOval(
                                  child: SizedBox.fromSize(
                                      size: Size.fromRadius(48),
                                      child: profileImage == null
                                          ? _user.buildImage(fit: BoxFit.cover)
                                          : Image.file(
                                              File(profileImage!.path),
                                              fit: BoxFit.cover,
                                            ))),
                              Positioned(
                                top: -5,
                                right: -5,
                                child: IconButton(
                                    onPressed: () async {
                                      selectImage(_user);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: MColors.green,
                                    )),
                              )
                            ])),
                        Spacer(flex: 1),
                        Flexible(
                          flex: 4,
                          child: Center(
                            child: Column(
                              children: [
                                buildName(_user),
                                // NumbersWidget(_user!),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildAbout(_user),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: GetUserContactWidget(
                        PrepareContacts(contacts), context),
                  ),
                  const SizedBox(height: 48),
                  ItemsListViewSelfProfile(
                    _user.id,
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget buildContacts(BuildContext context, UserController controller) {
    return FutureBuilder(
        future: controller.getUserContact(SharedPrefs().userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (!snapshot.hasData) {
            return SizedBox(
                height: 40, child: CircularProgressIndicator.adaptive());
          }
          var contacts = snapshot.data as List<UserContact>;
          return GetUserContactWidget(PrepareContacts(contacts), context);
        });
  }

  List<UserContact> PrepareContacts(List<UserContact> contacts) {
    Map<UserContactType, UserContact> contactsMap = {
      UserContactType.TELEGRAM:
          UserContact(contact: "", type: UserContactType.TELEGRAM),
      UserContactType.WHATSAPP:
          UserContact(contact: "", type: UserContactType.WHATSAPP),
      UserContactType.PHONE:
          UserContact(contact: "", type: UserContactType.PHONE)
    };
    for (var contact in contacts) {
      if (contactsMap.containsKey(contact.type)) {
        contactsMap[contact.type] = contact;
      }
    }
    List<UserContact> result = [];
    contactsMap.forEach((key, value) {
      result.add(value);
    });
    return result;
  }

  Widget GetUserContactWidget(
      List<UserContact> contacts, BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          var controller = TextEditingController();
          if (contacts[index].contact.length > 0) {
            controller.text = contacts[index].contact;
          }
          return Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(
                contacts[index].contactIcon,
                size: 24,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: EditableContactTextField(
                    contacts[index], _userController,
                    callback: () => setState(() {})))
          ]);
        });
  }

  Widget buildName(User user) => Column(
        children: [
          EditableTextField(
              _userNameController.text,
              () => _userNameController.text.isNotEmpty
                  ? saveUser(context)
                  : null,
              _userNameController),
          const SizedBox(height: 4),
        ],
      );

  Widget buildAbout(User user) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'О себе',
              style: getBigTextStyle(),
            ),
            const SizedBox(height: 8),
            EditableTextField(
                _bioController.text,
                () => _bioController.text.isNotEmpty ? saveUser(context) : null,
                _bioController),
          ],
        ),
      );

  Future<bool> _deleteDialogBuilder(BuildContext context) async {
    bool _result = false;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы точно хотите удалить свой аккаунт?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                _result = true;
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Нет'),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ],
        );
      },
    );
    return _result;
  }

  Future<bool> _logoutDialog(BuildContext context) async {
    bool _result = false;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Разлогиниться'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                _result = true;
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Нет'),
              onPressed: () {},
            ),
          ],
        );
      },
    );
    return _result;
  }

  List<Widget> _getActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.delete_forever,
          color: context.theme.colorScheme.error,
        ),
        onPressed: () async {
          if (await _deleteDialogBuilder(context)) {
            if (await _userController.DeleteMyself()) {
              showSnackBar(context, 'До скорых встреч');
              GoRouter.of(context).go(SMPath.start);
            }
          }
        },
      ),
      IconButton(
        icon: Icon(
          Icons.logout_rounded,
          color: context.theme.colorScheme.error,
        ),
        onPressed: () async {
          if (await _logoutDialog(context)) {
            if (await _userController.Logout()) {
              showSnackBar(context, 'До скорых встреч');
              GoRouter.of(context).go(SMPath.start);
            }
          }
        },
      ),
      SizedBox(
        width: context.width * 0.05,
      ),
    ];
  }

  Future<bool> selectImage(User user) async {
    var source = await chooseImageSource(
        context, "Вы можете выбрать изображение профиля");
    var image = await imagePicker.pickImage(source: source);
    if (image == null) {
      return false;
    }
    image = await compressImage(image, 128 * 1024);
    if (!await _userController.UpdateUserPhoto(image)) {
      showErrorScaffold(context, "Не получилось загрузить изображение");
      return false;
    }
    CachedImage.EvictUserProfileImage(SharedPrefs().userId);
    setState(() {
      profileImage = image;
    });
    return true;
  }

  Future<bool> saveUser(BuildContext context) async {
    var newUser = User(
        id: SharedPrefs().userId,
        username: _userNameController.text,
        bio: _bioController.text);

    if (!await _userController.UpdateUser(newUser, profileImage)) {
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
