import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/services/user_service.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/user/page/user_actions.dart';
import 'package:sharing_map/utils/chose_image_source.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/utils/compress_image.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/widgets/allWidgets.dart';
import 'package:sharing_map/widgets/image.dart';
import 'package:sharing_map/widgets/editable_text.dart';
import 'package:sharing_map/widgets/need_registration.dart';

class _AchievementInfo {
  final String name;
  final String imageAssetPath;
  final int minTransferredItems;
  final String description;

  const _AchievementInfo({
    required this.name,
    required this.imageAssetPath,
    required this.minTransferredItems,
    required this.description,
  });
}

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
  Future<int>? _transferredItemsCountFuture;
  final List<_AchievementInfo> _achievements = const [
    _AchievementInfo(
      name: "name1",
      imageAssetPath: "assets/images/achievement_vase_1.jpg",
      minTransferredItems: 5,
      description: "Шаблонный текст для пояснения первой ачивки.",
    ),
    _AchievementInfo(
      name: "name2",
      imageAssetPath: "assets/images/achievement_vase_2.jpg",
      minTransferredItems: 10,
      description: "Шаблонный текст для пояснения второй ачивки.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    final userId = SharedPrefs().userId;
    _transferredItemsCountFuture = userId.isEmpty
        ? Future.value(0)
        : UserWebService.getTransferredItemsCount(userId);
  }

  @override
  Widget build(BuildContext context) {
    var _user = _userController.myself;
    var contacts = _userController.myContacts;
    _bioController.text = _user.value.bio ?? "";
    _userNameController.text = _user.value.username;
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: MColors.secondaryGreen,
            onPressed: () => context.pop(),
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
                                child:
                                    _userController.userProfilePicture.value)),
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
                            _user.value.bio?.isEmpty ?? true
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
                                    _user.value.bio ?? "",
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
                            const SizedBox(height: 16),
                            buildAchievementsSection(),
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

  Widget buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ачивки",
          style: getBigTextStyle(),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 30),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: FutureBuilder<int>(
            future: _transferredItemsCountFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                );
              }

              if (snapshot.hasError) {
                return Text(
                  "Не удалось загрузить ачивки",
                  style: getHintTextStyle(),
                );
              }

              final transferredItemsCount = snapshot.data ?? 0;
              return Column(
                children: _achievements
                    .map((achievement) => buildAchievementCard(
                          achievement,
                          transferredItemsCount,
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildAchievementCard(
      _AchievementInfo achievement, int transferredItemsCount) {
    final isUnlocked = transferredItemsCount > achievement.minTransferredItems;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => showAchievementDialog(achievement, isUnlocked),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Opacity(
              opacity: isUnlocked ? 1 : 0.35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  achievement.imageAssetPath,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.name,
                    style: getMediumTextStyle(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUnlocked
                        ? "Открыта"
                        : "Нужно передать больше ${achievement.minTransferredItems} вещей",
                    style: getHintTextStyle(),
                  ),
                ],
              ),
            ),
            Icon(
              isUnlocked ? Icons.emoji_events : Icons.lock_outline,
              color: isUnlocked ? MColors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void showAchievementDialog(_AchievementInfo achievement, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final maxImageHeight = screenSize.height * 0.5;
        final maxImageWidth = screenSize.width * 0.8;

        return AlertDialog(
          title: Text(achievement.name),
          content: SizedBox(
            width: maxImageWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: maxImageHeight,
                          maxWidth: maxImageWidth,
                        ),
                        child: Image.asset(
                          achievement.imageAssetPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isUnlocked
                        ? achievement.description
                        : "Шаблонный текст: ачивка будет открыта после выполнения условия.",
                    style: getMediumTextStyle(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Закрыть"),
            ),
          ],
        );
      },
    );
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
