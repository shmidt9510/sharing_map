// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sharing_map/items/controllers/item_controller.dart';
// import 'package:get/get.dart';
// import 'package:sharing_map/items/models/item.dart';
// import 'package:sharing_map/items/item_block.dart';

// const Color kErrorRed = Colors.redAccent;
// const Color kDarkGray = Color(0xFFA3A3A3);
// const Color kLightGray = Color(0xFFF1F0F5);

// enum PhotoSource { FILE, NETWORK }

// class ImagePickerWidget extends StatefulWidget {
//   @override
//   _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
// }

// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   List<File> _photos = [];
//   List<String> _photosUrls = [];
//   List<PhotoSource> _photosSources = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             height: 100,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _photos.length + 1,
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   return _buildAddPhoto();
//                 }
//                 File image = _photos[index - 1];
//                 PhotoSource source = _photosSources[index - 1];
//                 return Stack(
//                   children: [
//                     InkWell(
//                       child: Container(
//                         margin: EdgeInsets.all(5),
//                         height: 100,
//                         width: 100,
//                         color: kLightGray,
//                         child: source == PhotoSource.FILE
//                             ? Image.file(image)
//                             : Image.network(_photosUrls[index - 1]),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildAddPhoto() {
//     return InkWell(
//       child: Container(
//         margin: EdgeInsets.all(5),
//         height: 100,
//         width: 100,
//         color: kDarkGray,
//         child: Center(
//           child: Icon(
//             Icons.add_a_photo,
//             color: kLightGray,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class ImagePickerWidget extends StatefulWidget {
// //   const ImagePickerWidget({Key? key}) : super(key: key);
// //   @override
// //   State<ImagePickerWidget> createState() => _ImagePickerState();
// // }

// // class _ImagePickerState extends State<ImagePickerWidget> {
// //   final ImagePicker imagePicker = ImagePicker();

// //   List<XFile>? imageFileList = [];

// //   void selectImages() async {
// //     final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
// //     if (selectedImages!.isNotEmpty) {
// //       imageFileList!.addAll(selectedImages);
// //     }
// //     setState(() {});
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Column(
// //         children: [
// //           MaterialButton(
// //               color: Colors.blue,
// //               child: const Text("Pick Images from Gallery",
// //                   style: TextStyle(
// //                       color: Colors.white70, fontWeight: FontWeight.bold)),
// //               onPressed: () {
// //                 selectImages();
// //               }),
// //           SizedBox(
// //             height: 20,
// //           ),
// //           Expanded(
// //               child: Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: GridView.builder(
// //                 itemCount: imageFileList!.length,
// //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 3),
// //                 itemBuilder: (BuildContext context, int index) {
// //                   return Image.file(File(imageFileList![index].path),
// //                       fit: BoxFit.cover);
// //                 }),
// //           ))
// //         ],
// //       ),
// //     );
// //   }
// // }
