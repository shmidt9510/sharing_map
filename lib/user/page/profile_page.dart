import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/user/page/editable_contact_text_field.dart';
import 'package:sharing_map/utils/shared.dart';
import 'package:sharing_map/screens/items/item_widgets.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.green,
          onPressed: () => GoRouter.of(context).go(SMPath.home),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: _getActions(context),
      ),
      body: FutureBuilder(
          future: _userController.GetMyself(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var _user = snapshot.data as User;
            return Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.height / 5,
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.only(start: 20, end: 20),
                          child: Row(
                            children: [
                              Flexible(flex: 1, child: _user.buildImage()),
                              Flexible(
                                flex: 2,
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
                      ),
                      const SizedBox(height: 10),
                      buildAbout(_user),
                      buildContacts(context, _userController),
                      const SizedBox(height: 48),
                      ItemsListView(
                        userId: _user.id,
                        addDeleteButton: true,
                      )
                    ],
                  ),
                ),
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
          Text(
            user.username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'О себе',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                user.bio,
                style: TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
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
              onPressed: () {
                GoRouter.of(context).go(SMPath.start);
              },
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
              //TODO
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
      IconButton(
        icon: Icon(
          Icons.edit,
          color: context.theme.secondaryHeaderColor,
        ),
        onPressed: () {
          GoRouter.of(context).go(SMPath.profile + "/" + SMPath.profileEdit);
        },
      ),
    ];
  }
}
