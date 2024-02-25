import 'package:flutter/cupertino.dart';
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
      return AlertDialog.adaptive(
          title: Row(
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
                      ? Icon(FontAwesomeIcons.solidCircleCheck)
                      : Icon(FontAwesomeIcons.copy))
            ],
          ),
          actions: [
            widget.canShow
                ? adaptiveAction(
                    context: context,
                    onPressed: () {
                      launchUrl(widget.url);
                      Navigator.pop(context);
                    },
                    child: const Text('Перейти'),
                  )
                : Container(),
          ]);
    });
  }

  Widget adaptiveAction(
      {required BuildContext context,
      required VoidCallback onPressed,
      required Widget child}) {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextButton(onPressed: onPressed, child: child);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(onPressed: onPressed, child: child);
    }
  }
}
