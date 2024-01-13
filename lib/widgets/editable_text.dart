import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
                enabled: _isEditing,
                decoration: InputDecoration(
                  hintMaxLines: 5,
                  hintText: widget.hint,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              size: 12.0,
            ),
            onPressed: _toggleEditing,
          ),
        ],
      ),
    );
  }
}
