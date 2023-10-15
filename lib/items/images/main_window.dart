import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sharing_map/items/images/custom_dialog.dart';
import 'package:sharing_map/items/images/upload_file.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'delete_widget.dart';
import 'gallery_item.dart';
import 'gallery_photo_wrapper.dart';
import 'generate_image_url.dart';

const Color kErrorRed = Colors.redAccent;
const Color kDarkGray = Color(0xFFA3A3A3);
const Color kLightGray = Color(0xFFF1F0F5);

enum PhotoStatus { LOADING, ERROR, LOADED }

enum PhotoSource { FILE, NETWORK }

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<XFile> _photos = [];
  List<String> _photosUrls = [];

  List<PhotoStatus> _photosStatus = [];
  List<PhotoSource> _photosSources = [];
  List<GalleryItem> _galleryItems = [];

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();

    loadImages();
  }

  loadImages() async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<String>? photos = sharedPreferences.getStringList("images");
    if (photos == null) {
      return;
    }

    int length = photos.length;

    _galleryItems = List.generate(
      length,
      (index) => GalleryItem(
        isSvg: false,
        id: Uuid().v1(),
        resource: photos[index],
      ),
    );
    _photos = List.generate(
      length,
      (index) => XFile(
        photos[index],
      ),
    );
    _photosUrls = List.generate(
      length,
      (index) => photos[index],
    );
    _photosStatus = List.generate(
      length,
      (index) => PhotoStatus.LOADED,
    );
    _photosSources = List.generate(
      length,
      (index) => PhotoSource.NETWORK,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _photos.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAddPhoto();
                }
                XFile image = _photos[index - 1];
                PhotoSource source = _photosSources[index - 1];
                return Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () => _onPhotoClicked(index - 1),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        height: 100,
                        width: 100,
                        color: kLightGray,
                        child: source == PhotoSource.FILE
                            ? Image.file(File(image.path))
                            : Image.network(_photosUrls[index - 1]),
                      ),
                    ),
                    Visibility(
                      visible: _photosStatus[index - 1] == PhotoStatus.LOADING,
                      child: Positioned.fill(
                        child: SpinKitWave(
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _photosStatus[index - 1] == PhotoStatus.ERROR,
                      child: Positioned.fill(
                        child: Icon(
                          Icons.error,
                          color: kErrorRed,
                          size: 35,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        padding: EdgeInsets.all(6),
                        alignment: Alignment.topRight,
                        child: DeleteWidget(
                          () => _onDeleteReviewPhotoClicked(index - 1),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          // Container(
          //   margin: EdgeInsets.all(16),
          //   child: ElevatedButton(
          //     child: Text('Save'),
          //     onPressed: _onSaveClicked,
          //   ),
          // )
        ],
      ),
    );
  }

  // _onSaveClicked() async {
  //   try {
  //     sharedPreferences = await SharedPreferences.getInstance();
  //     await sharedPreferences.setStringList("images", _photosUrls);
  //     print('Successfully saved');
  //   } catch (e) {
  //     print('Error saving ');
  //   }
  // }

  Future<bool> _onDeleteReviewPhotoClicked(int index) async {
    if (_photosStatus[index] == PhotoStatus.LOADED) {
      _photosUrls.removeAt(index);
    }
    _photos.removeAt(index);
    _photosStatus.removeAt(index);
    _photosSources.removeAt(index);
    _galleryItems.removeAt(index);
    setState(() {});
    return true;
  }

  _buildAddPhoto() {
    return InkWell(
      onTap: () => _onAddPhotoClicked(context),
      child: Container(
        margin: EdgeInsets.all(5),
        height: 100,
        width: 100,
        color: kDarkGray,
        child: Center(
          child: Icon(
            Icons.add_to_photos,
            color: kLightGray,
          ),
        ),
      ),
    );
  }

  _onAddPhotoClicked(context) async {
    Permission permission;

    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }

    PermissionStatus permissionStatus = await permission.status;

    print(permissionStatus);

    if (permissionStatus == PermissionStatus.restricted) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await permission.request();

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      print('Permission granted');

      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        int length;
        length = _photos.length + 1;

        String fileExtension = path.extension(image.path);

        _galleryItems.add(
          GalleryItem(
            id: Uuid().v1(),
            resource: image.path,
            isSvg: fileExtension.toLowerCase() == ".svg",
          ),
        );

        setState(() {
          _photos.add(image);
          _photosStatus.add(PhotoStatus.LOADING);
          _photosSources.add(PhotoSource.FILE);
        });

        try {
          GenerateImageUrl generateImageUrl = GenerateImageUrl();
          await generateImageUrl.call(fileExtension);

          String uploadUrl;
          if (generateImageUrl.isGenerated) {
            uploadUrl = generateImageUrl.uploadUrl;
          } else {
            throw generateImageUrl.message;
          }

          bool isUploaded =
              await uploadFile(context, Uri(path: uploadUrl), image);
          if (isUploaded) {
            print('Uploaded');
            setState(() {
              _photosUrls.add(generateImageUrl.downloadUrl);
              _photosStatus
                  .replaceRange(length - 1, length, [PhotoStatus.LOADED]);
              _galleryItems[length - 1].resource = generateImageUrl.downloadUrl;
            });
          }
        } catch (e) {
          print(e);
          setState(() {
            _photosStatus[length - 1] = PhotoStatus.ERROR;
          });
        }
      }
    }
  }

  _showOpenAppSettingsDialog(context) {
    return CustomDialog.show(
        context,
        'Permission needed',
        'Photos permission is needed to select photos',
        'Open settings',
        openAppSettings);
  }

  Future<bool> uploadFile(context, Uri url, XFile image) async {
    try {
      UploadFile uploadFile = UploadFile();
      await uploadFile.call(url, image);

      if (uploadFile.isUploaded ?? false) {
        return true;
      } else {
        throw uploadFile.message ?? "NO ERROR MESSAGE";
      }
    } catch (e) {
      throw e;
    }
  }

  _onPhotoClicked(int index) {
    if (_photosStatus[index] == PhotoStatus.ERROR) {
      print("Try uploading again");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: _galleryItems,
          photoStatus: _photosStatus[index],
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
