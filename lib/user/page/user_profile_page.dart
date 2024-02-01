import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/screens/items/item_widgets_other_profile.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  UserProfilePage({required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: _userController.GetUser(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                child: Text("Что-то пошло не так"),
              );
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var _user = snapshot.data as User;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: context.height / 5,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(start: 20, end: 20),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: ClipOval(
                                    child: SizedBox.fromSize(
                                        size: Size.fromRadius(
                                            context.width * 0.15),
                                        child: _user.buildImage(
                                            fit: BoxFit.cover)))),
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
                    const SizedBox(height: 48),
                    ItemsListViewOtherProfile(_user.id)
                  ],
                ),
              ),
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
            user.email ?? "",
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
