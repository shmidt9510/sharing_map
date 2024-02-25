import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharing_map/theme.dart';

Future<ImageSource?> chooseImageSource(
    BuildContext context, String text) async {
  ImageSource? _chosenSource = null;
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(text, style: getSmallTextStyle()),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Камера'),
            onPressed: () {
              _chosenSource = ImageSource.camera;
              Navigator.of(context).maybePop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Галерея'),
            onPressed: () {
              _chosenSource = ImageSource.gallery;
              Navigator.of(context).maybePop();
            },
          ),
        ],
      );
    },
  );
  return _chosenSource;
}
