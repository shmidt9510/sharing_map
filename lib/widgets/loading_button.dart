import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';

class LoadingButton extends StatefulWidget {
  final String labelText;
  final Future<void> Function() onPressed;
  final Color color = MColors.secondaryGreen;
  final double height = 50;
  final TextStyle? textStyle = null;

  LoadingButton(this.labelText, this.onPressed,
      {Color color = MColors.secondaryGreen,
      double height = 50,
      TextStyle? textStyle});

  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var textStyle = widget.textStyle;
    if (textStyle == null) {
      textStyle = getMediumTextStyle();
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: textStyle,
        backgroundColor: widget.color,
        minimumSize: Size.fromHeight(widget.height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await widget.onPressed.call();
              } catch (e) {
                debugPrint("catch " + e.toString());
              }
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? CircularProgressIndicator.adaptive()
          : getBody(textStyle),
    );
  }

  Widget getBody(TextStyle textStyle) {
    return Text(
      widget.labelText,
      style: textStyle,
    );
    //   }
    //   if (_result!) {
    //     return Icon(
    //       Icons.check,
    //       color: MColors.darkGreen,
    //     );
    //   } else {
    //     return Icon(FontAwesomeIcons.cross, color: MColors.red1);
    //   }
  }
}
