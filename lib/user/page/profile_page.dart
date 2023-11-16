import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/user/widgets/numbers.dart';
import 'package:sharing_map/user/widgets/profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserController _userController = Get.find<UserController>();
  User? _user = null;
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
          onPressed: () => Navigator.of(context).pop(),
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
            _user = snapshot.data as User;
            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: ProfileWidget(
                            user: _user!,
                            onClicked: () async {},
                          )),
                      Flexible(
                          flex: 2,
                          child: Column(
                            children: [
                              buildName(_user!),
                              NumbersWidget(_user!),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                buildAbout(_user!),
              ],
            );
          }),
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

  Future<bool> _deleteDialogBuilder(BuildContext context) async {
    bool _result = false;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вы точно хотите удалить свой аккаунт?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                _result = true;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Нет'),
              onPressed: () {
                Navigator.of(context).pop();
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
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Да'),
              onPressed: () {
                _result = true;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Нет'),
              onPressed: () {
                Navigator.of(context).pop();
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('До скорых встреч'),
                action: SnackBarAction(
                  label: 'Закрыть',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              ));
              await Future.delayed(const Duration(seconds: 2));
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
                content: const Text('Ты заходи, если что'),
                action: SnackBarAction(
                  label: 'Закрыть',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              ));
              await Future.delayed(const Duration(seconds: 2));
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
