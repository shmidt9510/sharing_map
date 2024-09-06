import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/controllers/item_controller.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/models/user.dart';
import 'package:sharing_map/path.dart';
import 'package:sharing_map/screens/items/item_widgets_self_profile.dart';
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

class EditProfileBioPage extends StatefulWidget {
  @override
  _EditProfileBioPageState createState() => _EditProfileBioPageState();
}

class _EditProfileBioPageState extends State<EditProfileBioPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
