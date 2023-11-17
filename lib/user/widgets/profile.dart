import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/models/user.dart';

class ProfileWidget extends StatelessWidget {
  final User user;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.user,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(child: buildImage());
  }

  Widget buildImage() {
    final image = user.buildImage().Get();

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(child: image, onTap: onClicked
            // fit: BoxFit.cover,
            // width: 128,
            // height: 128,
            // child: InkWell(onTap: onClicked),
            ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
