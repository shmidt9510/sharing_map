import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/allWidgets.dart';

class EditableContactTextField extends StatefulWidget {
  UserContact userContact;
  UserController userController;
  final Function callback;
  EditableContactTextField(this.userContact, this.userController,
      {required this.callback});
  @override
  _EditableContactTextFieldState createState() =>
      _EditableContactTextFieldState();
}

class _EditableContactTextFieldState extends State<EditableContactTextField> {
  bool _isEditing = false;
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditing() async {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (!_isEditing) {
      var id = widget.userContact.id;
      bool hasId = id == null ? false : id.isNotEmpty;
      if (_controller.text.isEmpty && hasId) {
        await _deleteContact(id);
        setState(() {
          _controller.clear();
        });
        widget.callback();
        return;
      }
      String? errorMessage =
          widget.userContact.checkFunction(_controller.text.toLowerCase());
      if (errorMessage == null) {
        if (_controller.text.isEmpty) {
          showErrorScaffold(context, "Попытка сохранить пустой текст");
          return;
        }
        await _saveContact(UserContact(
            id: widget.userContact.id,
            contact: _controller.text.toLowerCase(),
            type: widget.userContact.type));
        widget.callback();
      } else {
        setState(() {
          _controller.text = '';
        });
        showErrorScaffold(context, errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userContact.contact.isNotEmpty) {
      _controller.text = widget.userContact.contact;
    }
    return SizedBox(
      width: context.width * 0.7,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: TextFormField(
                  controller: _controller,
                  enabled: _isEditing,
                  style: getMediumTextStyle(),
                  decoration: InputDecoration(
                      hintText: widget.userContact.getHintString,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: MColors.secondaryGreen),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              size: 16.0,
            ),
            onPressed: _toggleEditing,
          ),
        ],
      ),
    );
  }

  Future<void> _saveContact(UserContact contact) async {
    UserController _userController = Get.find<UserController>();
    widget.userContact = await _userController.saveContact(contact);
    setState(() {
      bool wasUpdated = false;
      for (var i = 0; i < widget.userController.myContacts.length; i++) {
        if (widget.userController.myContacts[i].id == contact.id) {
          wasUpdated = true;
          widget.userController.myContacts[i] = contact;
          break;
        }
      }
      if (!wasUpdated) {
        widget.userController.myContacts.add(contact);
      }
    });
  }

  Future<void> _deleteContact(String contactId) async {
    UserController _userController = Get.find<UserController>();
    if (!await _userController.deleteContact(contactId)) {
      showErrorScaffold(context, "Не получилось удалить контакт");
    }
    setState(() {
      for (var i = 0; i < widget.userController.myContacts.length; i++) {
        if (widget.userController.myContacts[i].id == (contactId)) {
          widget.userController.myContacts.removeAt(i);
          break;
        }
      }
    });
  }
}
