import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/controllers/user_controller.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:sharing_map/widgets/allWidgets.dart';

class EditableContactTextField extends StatefulWidget {
  UserContact userContact;
  final Function callback;
  EditableContactTextField(this.userContact, {required this.callback});
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
      String? errorMessage = widget.userContact.checkFunction(_controller.text);
      if (errorMessage == null) {
        await _function(UserContact(
            id: widget.userContact.id,
            contact: _controller.text,
            type: widget.userContact.type));
        widget.callback();
      } else {
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

  Future<void> _function(UserContact contact) async {
    UserController _userController = Get.find<UserController>();
    widget.userContact = await _userController.saveContact(contact);
    setState(() {});
  }
}
