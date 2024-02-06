import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';

class EditableTextField extends StatefulWidget {
  final String hint;
  final VoidCallback onPressed;
  final TextEditingController controller;
  EditableTextField(this.hint, this.onPressed, this.controller);
  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  bool _isEditing = false;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (!_isEditing) {
      widget.onPressed.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.7,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: TextFormField(
                maxLines: null,
                // expands: true,
                keyboardType: TextInputType.multiline,
                controller: widget.controller,
                style: getMediumTextStyle(),
                enabled: _isEditing,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintMaxLines: 5,
                    hintText: widget.hint,
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
}
