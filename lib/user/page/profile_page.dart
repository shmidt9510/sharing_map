import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/screens/items/item_widgets.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/image.dart';
import 'package:sharing_map/widgets/editable_text.dart';

// D:\sharingMap\sharing_map\shaaring_map\lib\widgets\editable_text.dart
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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: MColors.secondaryGreen,
          onPressed: () => GoRouter.of(context).go(SMPath.home),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: _getActions(context),
      ),
      body: FutureBuilder(
          future: _userController.GetMyself(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(children: [
                  Text("Чтобы редактировать профиль надо зарегестрироваться"),
                  SizedBox(
                    height: 10,
                  ),
                  getButton(context, "Регистрируемся?", () {
                    GoRouter.of(context)
                        .go(SMPath.start + "/" + SMPath.registration);
                  })
                ]),
              );
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
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
                                      child:
                                          _user.buildImage(fit: BoxFit.cover))),
                              Positioned(
                                top: -5,
                                right: -5,
                                child: IconButton(
                                    onPressed: () async {
                                      selectImage();
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
                    child: buildContacts(context, _userController),
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
            return Center(child: CircularProgressIndicator.adaptive());
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
                child: EditableContactTextField(contacts[index],
                    callback: () =>
                        setState(() {})) //Text(contacts[index].contact),
                )
          ]);
        });
  }

  Widget buildName(User user) => Column(
        children: [
          EditableTextField(_userNameController.text, () => saveUser(context),
              _userNameController),
          const SizedBox(height: 4),
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'О себе',
              style: getBigTextStyle(),
            ),
            const SizedBox(height: 8),
            EditableTextField(
                _bioController.text, () => saveUser(context), _bioController),
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('До скорых встреч'),
                action: SnackBarAction(
                  label: 'Закрыть',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              ));
              await Future.delayed(const Duration(seconds: 1));
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('До скорых встреч'),
                action: SnackBarAction(
                  label: 'Закрыть',
                  onPressed: () {},
                ),
              ));
              await Future.delayed(const Duration(seconds: 1));
              GoRouter.of(context).go(SMPath.start);
            }
          }
        },
      ),
      SizedBox(
        width: context.width * 0.05,
      ),
      // IconButton(
      //   icon: Icon(
      //     Icons.edit,
      //     color: context.theme.secondaryHeaderColor,
      //   ),
      //   onPressed: () {
      //     GoRouter.of(context).go(SMPath.profile + "/" + SMPath.profileEdit);
      //   },
      // ),
    ];
  }

  void selectImage() async {
    var source = await _dialogBuilder(context);
    profileImage = await imagePicker.pickImage(source: source);
    if (profileImage == null) {
      return;
    }
    if (!await _userController.UpdateUserPhoto(profileImage!) ||
        !await CachedImage.EvictUserProfileImage(SharedPrefs().userId)) {
      var snackBar = SnackBar(
        content: const Text(
            'Изображение должно было поменяться, попобуйте перезагрузить приложение. Уже знаем об этом и чиним :('),
        action: SnackBarAction(
          label: 'Закрыть',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {});
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

  Future<ImageSource> _dialogBuilder(BuildContext context) async {
    ImageSource _chosenSource = ImageSource.gallery;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы можете выбрать одно изображение'),
          actions: [
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
}
