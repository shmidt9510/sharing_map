import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/user/page/editable_contact_text_field.dart';
import 'package:sharing_map/utils/shared.dart';

class EditProfileContactPage extends StatefulWidget {
  @override
  _EditProfileContactPageState createState() => _EditProfileContactPageState();
}

class _EditProfileContactPageState extends State<EditProfileContactPage> {
  UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    UserController _userController = Get.find<UserController>();
    var contacts = _userController.myContacts;

    return Scaffold(
        appBar: AppBar(title: Text("Редактировать контакты")),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 40.0, bottom: 40, left: 40, right: 1),
          child: Column(
            children: [buildContacts(context, _userController)],
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
}
