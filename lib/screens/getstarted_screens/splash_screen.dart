// import 'package:flutter/material.dart';
// import 'package:sharing_map/utils/colors.dart';
// import 'package:flutter_svg/svg.dart';
// import 'dart:async';
// import 'package:intro_slider/intro_slider.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   SplashScreenState createState() => SplashScreenState();
// }

// class SplashScreenState extends State<SplashScreen> {
//   List<Slide> slides = [];

//   @override
//   void initState() {
//     super.initState();

//     slides.add(
//       new Slide(
//         title: "ERASER",
//         description:
//             "Allow miles wound place the leave had. To sitting subject no improve studied limited",
//         pathImage: "assets/images/intro/intro_1.png",
//         backgroundColor: MColors.primaryGreen,
//       ),
//     );
//     slides.add(
//       new Slide(
//         title: "PENCIL",
//         description:
//             "Ye indulgence unreserved connection alteration appearance",
//         pathImage: "assets/images/intro/intro_2.svg",
//         backgroundColor: MColors.primaryGreen,
//       ),
//     );
//     slides.add(
//       new Slide(
//         title: "RULER",
//         description:
//             "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
//         pathImage: "assets/images/intro/intro_3.svg",
//         backgroundColor: MColors.primaryGreen,
//       ),
//     );
//   }

//   void onDonePress() {
//     // Do what you want
//     print("End of slides");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new IntroSlider(
//       slides: this.slides,
//       onDonePress: this.onDonePress,
//     );
//   }
// }
// // class SplashScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: MColors.primaryGreen,
// //       child: Center(
// //         child: Container(
// //           height: 45.0,
// //           child: SvgPicture.asset("images/intro/intro_1.svg"),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class SplashScreen extends StatefulWidget {
// //   @override
// //   Splash createState() => Splash();
// // }

// // class Splash extends State<SplashScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Timer(
// //     //     Duration(seconds: 300),
// //     //     () => Navigator.of(context).pushReplacement(MaterialPageRoute(
// //     //         builder: (BuildContext context) => SplashScreen())));

// //     // var assetsImage = new  //<- Creates an object that fetches an image.
// //     // var image = new Image(
// //     //     image: assetsImage,
// //     //     height:300); //<- Creates a widget that displays an image.

// //     return Center(
// //       child: Container(
// //         decoration: BoxDecoration(color: Colors.blue),
// //         child: SvgPicture.asset("assets/images/intro/intro_1.png"),
// //       ),
// //     );
// //   }
// // }
