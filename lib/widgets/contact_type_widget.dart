import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sharing_map/models/contact.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTypeButton extends StatefulWidget {
  UserContact contact;

  ContactTypeButton(this.contact);

  @override
  GetContactButtonState createState() => GetContactButtonState();
}

class GetContactButtonState extends State<ContactTypeButton> {
  bool _onPressed = false;
  @override
  Widget build(BuildContext context) {
    bool showContact = widget.contact.contact.isNotEmpty;
    final url = Uri.parse(widget.contact.getUri + widget.contact.contact);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter dialogState) {
      return showContact
          ? IconButton(
              icon: Icon(widget.contact.contactIcon),
              onPressed: () async {
                bool canShow = await canLaunchUrl(url);
                await showAdaptiveDialog(
                  context: context,
                  builder: (BuildContext context) => ContactTypeButtonDialog(
                      widget.contact.contact, canShow, url),
                );
              },
            )
          : Container();
    });
  }
}

class ContactTypeButtonDialog extends StatefulWidget {
  String contact;
  bool canShow;
  Uri url;
  ContactTypeButtonDialog(this.contact, this.canShow, this.url);

  @override
  ContactTypeButtonDialogState createState() => ContactTypeButtonDialogState();
}

class ContactTypeButtonDialogState extends State<ContactTypeButtonDialog> {
  bool _onPressed = false;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context,
        StateSetter dialogState /*You can rename this!*/) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText("${widget.contact}"),
                  IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: "${widget.contact}"));
                        dialogState(() {
                          _onPressed = true;
                        });
                      },
                      icon: _onPressed
                          ? Icon(FontAwesomeIcons.clipboardCheck)
                          : Icon(FontAwesomeIcons.clipboard))
                ],
              ),
              const SizedBox(height: 15),
              widget.canShow
                  ? TextButton(
                      onPressed: () {
                        launchUrl(widget.url);
                        Navigator.pop(context);
                      },
                      child: const Text('Перейти'),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
  }
}
