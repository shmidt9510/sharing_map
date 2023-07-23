// import 'package:flutter/material.dart';
// import 'package:sharing_map/model/notifiers/news_controller.dart';
// import 'package:get/get.dart';
// import 'package:sharing_map/utils/routes/router.dart';

// class HomeView extends StatefulWidget {
//   @override
//   _HomeViewState createState() => _HomeViewState();
// }

// const List<String> _defaultMaterials = <String>[
//   'poker',
//   'tortilla',
//   'fish and',
//   'micro',
//   'wood',
//   'hello',
//   'money',
//   'pets',
//   'house',
//   'sport',
// ];

// class _HomeViewState extends State<HomeView> {
//   // HomeView({super.key});

//   final NewsController _newsController = Get.put(NewsController());
//   // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   // final PageStorageBucket searchBucket = PageStorageBucket();
//   var query = "tesla";

//   @override
//   void initState() {
//     super.initState();
//   }

//   int _selectedIndex = 0;
//   // static const TextStyle optionStyle =
//   //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   // static const List<Widget> _widgetOptions = <Widget>[
//   //   Text(
//   //     'Index 0: Home',
//   //     style: optionStyle,
//   //   ),
//   //   Text(
//   //     'Index 1: Business',
//   //     style: optionStyle,
//   //   ),
//   //   Text(
//   //     'Index 2: School',
//   //     style: optionStyle,
//   //   ),
//   // ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       GoRouter.of(context).go(AppRouter.home(CurrentTab.values[index]));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var size = MediaQuery.of(context).size;
//     /*24 is for notification bar on Android*/
//     // final double itemHeight = (size.height) / 2.5;
//     // double _picHeight;

//     // if (itemHeight >= 315) {
//     //   _picHeight = itemHeight / 2;
//     // } else if (itemHeight <= 315 && itemHeight >= 280) {
//     //   _picHeight = itemHeight / 2.2;
//     // } else if (itemHeight <= 280 && itemHeight >= 200) {
//     //   _picHeight = itemHeight / 2.7;
//     // } else {
//     //   _picHeight = 30;
//     // }

//     // ProductsNotifier productsNotifier = Provider.of<ProductsNotifier>(context);
//     // var prods = productsNotifier.productsList;

//     // CartNotifier cartNotifier = Provider.of<CartNotifier>(context);
//     // var cartList = cartNotifier.cartList;
//     // var cartProdID = cartList.map((e) => e.productID);

//     // BannerAdNotifier bannerAdNotifier = Provider.of<BannerAdNotifier>(context);
//     // var bannerAds = bannerAdNotifier.bannerAdsList;

//     // BrandsNotifier brandsNotifier = Provider.of<BrandsNotifier>(context);
//     // var brands = brandsNotifier.brandsList;
//     // var bannerAds = _newsController.articles;
//     // int smth = 10;
//     return Scaffold(
//         appBar: AppBar(
//           leading: BackButton(
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(
//                 Icons.refresh_rounded,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 _newsController.fetchArticle();
//               },
//             ),
//           ],
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.business),
//               label: 'Business',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.school),
//               label: 'School',
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: Colors.amber[800],
//           onTap: _onItemTapped,
//         ),
//         body: Obx(() => _newsController.isLoading.value
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Column(children: [
//                 Flexible(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: List<Widget>.generate(_defaultMaterials.length,
//                           (int index) {
//                         return Container(
//                           margin: EdgeInsets.all(2.0),
//                           child: GestureDetector(
//                             onTap: () {
//                               _newsController
//                                   .fetchQuery(_defaultMaterials[index]);
//                               // _defaultMaterials[index];
//                               //Call a function to update your UI
//                             },
//                             child: Chip(
//                                 label: Text(
//                                     _defaultMaterials[index] ?? "NOTHING")),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//                 // Flexible(
//                 //   flex: 1,
//                 //   child: SizedBox(
//                 //     height: 100,
//                 //     // child: CarouselSlider.builder(
//                 //     child: CarouselSlider.builder(
//                 //       options: CarouselOptions(
//                 //         height: 40.0,
//                 //         enableInfiniteScroll: false,
//                 //         initialPage: 0,
//                 //         viewportFraction: 0.3,
//                 //         scrollPhysics: const BouncingScrollPhysics(),
//                 //       ),
//                 //       itemCount: _newsController.articles.length,
//                 //       itemBuilder: (context, index, smth) {
//                 //         return Container(
//                 //             width: MediaQuery.of(context).size.width,
//                 //             // margin: EdgeInsets.symmetric(horizontal: 5.0),
//                 //             decoration: const BoxDecoration(
//                 //               color: Color.fromRGBO(16, 208, 115, 0.549),
//                 //               borderRadius: BorderRadius.all(
//                 //                 Radius.circular(10.0),
//                 //               ),
//                 //               boxShadow: [
//                 //                 BoxShadow(
//                 //                   color: Color.fromRGBO(99, 6, 6, 0.42),
//                 //                   offset: Offset(0, 10),
//                 //                   blurRadius: 10,
//                 //                   // spreadRadius: 0
//                 //                 ),
//                 //               ],
//                 //             ),
//                 //             child: Text(
//                 //                 _newsController.articles[index].author ??
//                 //                     "NULL")
//                 //             // ClipRRect(
//                 //             //     borderRadius: BorderRadius.circular(10.0),
//                 //             //     child:
//                 //             //     // FadeInImage.assetNetwork(
//                 //             //     //   image: banner.bannerAd,
//                 //             //     //   fit: BoxFit.fill,
//                 //             //     //   placeholder: "assets/images/placeholder.jpg",
//                 //             //     //   placeholderScale:
//                 //             //     //       MediaQuery.of(context).size.width / 2,
//                 //             //     // ),
//                 //             //     ),
//                 //             );
//                 //       },
//                 //     ),
//                 //   ),
//                 // ),
//                 Flexible(
//                   flex: 9,
//                   child: ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       shrinkWrap: true,
//                       itemCount: _newsController.articles.length,
//                       physics: const BouncingScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: const EdgeInsets.all(5.0),
//                           padding: const EdgeInsets.all(15.0),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(5.0),
//                               border: Border.all(
//                                   color: const Color.fromRGBO(205, 213, 223, 1),
//                                   width: 1.0)),
//                           child: GestureDetector(
//                             onTap: () {
//                               _gotoDetailsPage(context, index);
//                             },
//                             child: Center(
//                               child: Text(
//                                 _newsController.articles[index].title!,
//                                 style: const TextStyle(
//                                   color: Color.fromRGBO(76, 85, 102, 1),
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                 )
//               ])));
//   }

//   void _gotoDetailsPage(BuildContext context, int index) {
//     Navigator.of(context).push(MaterialPageRoute<void>(
//       builder: (BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Second Page'),
//         ),
//         body: Column(
//           children: [
//             Hero(
//               tag: 'hero-rectangle',
//               child: Text(_newsController.articles[index].title!),
//             ),
//             Text(_newsController.articles[index].content!)
//           ],
//         ),
//       ),
//     ));
//   }
//   // return Scaffold(
//   //   backgroundColor: Colors.white,
//   //   appBar: AppBar(
//   //     elevation: 1.0,
//   //     backgroundColor: const Color(0xff535FF7),
//   //     centerTitle: true,
//   //     title: const Text(
//   //       'News',
//   //       style: TextStyle(color: Colors.white),
//   //     ),
//   //     actions: [

//   //       // IconButton(icon: const Icon(Icons.settings, color: Colors.black,), onPressed: () {
//   //       //   Navigator.push(context,
//   //       //       MaterialPageRoute(
//   //       //           builder: (context) => const SettingsAppBar()
//   //       //       )
//   //       //   );
//   //       // },)
//   //     ],
//   //     //   leading: IconButton(icon: const Icon(Icons.menu, color: Colors.black,), onPressed: () {
//   //     //     Navigator.push(context,
//   //     //         MaterialPageRoute(
//   //     //             builder: (context) => const MenuAppBar()
//   //     //         )
//   //     //     );
//   //     //   },
//   //     // ),
//   //   ),
// }

// class BoxWidget extends StatelessWidget {
//   const BoxWidget({super.key, required this.size});

//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: size.width,
//       height: size.height,
//       color: Colors.blue,
//     );
//   }
// }


// // }
// // class _ActionChoiceExampleState extends State<ActionChoiceExample> {
// //   int? _value = 1;

// //   @override
// //   Widget build(BuildContext context) {
// //     final TextTheme textTheme = Theme.of(context).textTheme;

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('ActionChoice Sample'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text('Choose an item', style: textTheme.labelLarge),
// //             const SizedBox(height: 10.0),
// //             Wrap(
// //               spacing: 5.0,
// //               children: List<Widget>.generate(
// //                 3,
// //                 (int index) {
// //                   return ChoiceChip(
// //                     label: Text('Item $index'),
// //                     selected: _value == index,
// //                     onSelected: (bool selected) {
// //                       setState(() {
// //                         _value = selected ? index : null;
// //                       });
// //                     },
// //                   );
// //                 },
// //               ).toList(),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
