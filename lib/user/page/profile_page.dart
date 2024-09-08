import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/user/page/editable_contact_text_field.dart';
import 'package:sharing_map/user/page/user_actions.dart';
import 'package:sharing_map/utils/chose_image_source.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/compress_image.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/image.dart';
import 'package:sharing_map/widgets/editable_text.dart';
import 'package:sharing_map/widgets/need_registration.dart';

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
    var _user = _userController.myself;
    var contacts = _userController.myContacts;
    _bioController.text = _user.value.bio;
    _userNameController.text = _user.value.username;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: MColors.secondaryGreen,
            onPressed: () => GoRouter.of(context).go(SMPath.home),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: SharedPrefs().logged ? [UserActionsWidget()] : null,
        ),
        body: _userController.myself.value.id == User.getEmptyUser().id
            ? NeedRegistration()
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                      child: Stack(children: [
                        ClipOval(
                            child: SizedBox.fromSize(
                                size: Size.fromRadius(90),
                                child: profileImage == null
                                    ? _user.value.buildImage(fit: BoxFit.cover)
                                    : Image.file(
                                        File(profileImage!.path),
                                        fit: BoxFit.cover,
                                      ))),
                        Positioned(
                          top: 130,
                          right: -5,
                          child: IconButton(
                              onPressed: () async {
                                selectImage(_user.value);
                              },
                              icon: Icon(
                                Icons.add_a_photo_rounded,
                                color: MColors.green,
                              )),
                        )
                      ]),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _userNameController.text,
                          style: getBigTextStyle(),
                        ),
                        IconButton(
                            onPressed: () {
                              GoRouter.of(context).go(
                                  SMPath.myItems + "/" + SMPath.profileEditBio);
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 16,
                            ))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      // width: context.width * 0.85,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'О себе',
                                  style: getBigTextStyle(),
                                ),
                                IconButton(
                                    onPressed: () {
                                      GoRouter.of(context).go(SMPath.myItems +
                                          "/" +
                                          SMPath.profileEditBio);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 16,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _user.value.bio.isEmpty
                                ? InkWell(
                                    onTap: () {
                                      GoRouter.of(context).go(SMPath.myItems +
                                          "/" +
                                          SMPath.profileEditBio);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add_circle_outline_rounded),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Расскажите немного о себе",
                                          style: getMediumTextStyle(),
                                        )
                                      ],
                                    ),
                                  )
                                : Text(
                                    _user.value.bio,
                                    style: getMediumTextStyle(),
                                  ),
                            // _user.value.
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Контакты',
                                  style: getBigTextStyle(),
                                ),
                                IconButton(
                                    onPressed: () {
                                      GoRouter.of(context).go(SMPath.myItems +
                                          "/" +
                                          SMPath.profileEditContact);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 16,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _userController.myContacts.isNotEmpty
                                ? GetUserContactWidget(
                                    PrepareContacts(contacts), context)
                                : InkWell(
                                    onTap: () {
                                      GoRouter.of(context).go(SMPath.myItems +
                                          "/" +
                                          SMPath.profileEditContact);
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add_circle_outline_rounded),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Добавьте контакты для связи",
                                          style: getHintTextStyle(),
                                        )
                                      ],
                                    ),
                                  ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
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
      if (value.contact.isNotEmpty) {
        result.add(value);
      }
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
          return Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(
                contacts[index].contactIcon,
                size: 24,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              contacts[index].contact,
              style: getMediumTextStyle(),
            ),
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

  Future<bool> selectImage(User user) async {
    var source = await chooseImageSource(
        context, "Вы можете выбрать изображение профиля");
    if (source == null) {
      return false;
    }
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
