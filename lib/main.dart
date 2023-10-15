import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_map/items/add_new_item_page.dart';
import 'package:sharing_map/items/controllers/item_controller.dart';
import 'package:sharing_map/screens/home.dart';
// import 'screens/getstarted_screens/intro_screen.dart';
// import 'screens/home_screens/home_test.dart';
import 'screens/getstarted_screens/get_start.dart';
import 'utils/colors.dart';
import 'package:sharing_map/items/controllers/common_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final CommonController _commonController = Get.put(CommonController());
  final ItemController _itemsController = Get.put(ItemController());
  bool _isFirstCall = false;
  @override
  void initState() {
    // _commonController.onInit();
    _itemsController.onInit();
    super.initState();
  }

  @override
  void dispose() {
    _itemsController.dispose();
    _commonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        restorationScopeId: "Test",
        title: "Sharing Map",
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: MColors.secondaryGreen,
            surfaceTintColor: MColors.primaryGreen,
            actionsIconTheme: const IconThemeData(color: Colors.white),
          ),
          secondaryHeaderColor: MColors.primaryGreen,
          primaryColor: MColors.secondaryGreen,
        ),
        debugShowCheckedModeBanner: false,
        home: _isFirstCall ? OnBoardingPage() : HomePage());
    // home: _isFirstCall ? OnBoardingPage() : AddNewItemPage());
  }

  static Future<bool> IsFirstCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstCall;
    try {
      firstCall = prefs.getBool("is_first_run") ?? true;
    } on Exception {
      firstCall = true;
    }
    await prefs.setBool("is_first_run", false);

    return firstCall;
  }
}

// import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blurhash/flutter_blurhash.dart';

// void main() {
//   CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;

//   runApp(
//     BaseflowPluginExample(
//       pluginName: 'CachedNetworkImage',
//       githubURL: 'https://github.com/Baseflow/flutter_cached_network_image',
//       pubDevURL: 'https://pub.dev/packages/cached_network_image',
//       pages: [
//         BasicContent.createPage(),
//         ListContent.createPage(),
//         GridContent.createPage(),
//       ],
//     ),
//   );
// }

// /// Demonstrates a [StatelessWidget] containing [CachedNetworkImage]
// class BasicContent extends StatelessWidget {
//   const BasicContent({super.key});

//   static ExamplePage createPage() {
//     return ExamplePage(Icons.image, (context) => const BasicContent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _blurHashImage(),
//             _sizedContainer(
//               const Image(
//                 image: CachedNetworkImageProvider(
//                   'https://via.placeholder.com/350x150',
//                 ),
//               ),
//             ),
//             _sizedContainer(
//               CachedNetworkImage(
//                 progressIndicatorBuilder: (context, url, progress) => Center(
//                   child: CircularProgressIndicator(
//                     value: progress.progress,
//                   ),
//                 ),
//                 imageUrl:
//                     'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
//               ),
//             ),
//             _sizedContainer(
//               CachedNetworkImage(
//                 placeholder: (context, url) =>
//                     const CircularProgressIndicator(),
//                 imageUrl: 'https://via.placeholder.com/200x150',
//               ),
//             ),
//             _sizedContainer(
//               CachedNetworkImage(
//                 imageUrl: 'https://via.placeholder.com/300x150',
//                 imageBuilder: (context, imageProvider) => Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: imageProvider,
//                       fit: BoxFit.cover,
//                       colorFilter: const ColorFilter.mode(
//                         Colors.red,
//                         BlendMode.colorBurn,
//                       ),
//                     ),
//                   ),
//                 ),
//                 placeholder: (context, url) =>
//                     const CircularProgressIndicator(),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             ),
//             CachedNetworkImage(
//               imageUrl: 'https://via.placeholder.com/300x300',
//               placeholder: (context, url) => const CircleAvatar(
//                 backgroundColor: Colors.amber,
//                 radius: 150,
//               ),
//               imageBuilder: (context, image) => CircleAvatar(
//                 backgroundImage: image,
//                 radius: 150,
//               ),
//             ),
//             _sizedContainer(
//               CachedNetworkImage(
//                 imageUrl: 'https://notAvalid.uri',
//                 placeholder: (context, url) =>
//                     const CircularProgressIndicator(),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             ),
//             _sizedContainer(
//               CachedNetworkImage(
//                 imageUrl: 'not a uri at all',
//                 placeholder: (context, url) =>
//                     const CircularProgressIndicator(),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             ),
//             _sizedContainer(
//               CachedNetworkImage(
//                 maxHeightDiskCache: 10,
//                 imageUrl: 'https://via.placeholder.com/350x200',
//                 placeholder: (context, url) =>
//                     const CircularProgressIndicator(),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//                 fadeInDuration: const Duration(seconds: 3),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _blurHashImage() {
//     return SizedBox(
//       width: double.infinity,
//       child: CachedNetworkImage(
//         placeholder: (context, url) => const AspectRatio(
//           aspectRatio: 1.6,
//           child: BlurHash(hash: 'LEHV6nWB2yk8pyo0adR*.7kCMdnj'),
//         ),
//         imageUrl: 'https://blurha.sh/assets/images/img1.jpg',
//         fit: BoxFit.cover,
//       ),
//     );
//   }

//   Widget _sizedContainer(Widget child) {
//     return SizedBox(
//       width: 300,
//       height: 150,
//       child: Center(child: child),
//     );
//   }
// }

// /// Demonstrates a [ListView] containing [CachedNetworkImage]
// class ListContent extends StatelessWidget {
//   const ListContent({super.key});

//   static ExamplePage createPage() {
//     return ExamplePage(Icons.list, (context) => const ListContent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemBuilder: (BuildContext context, int index) => Card(
//         child: Column(
//           children: <Widget>[
//             CachedNetworkImage(
//               imageUrl: 'https://loremflickr.com/320/240/music?lock=$index',
//               placeholder: (BuildContext context, String url) => Container(
//                 width: 320,
//                 height: 240,
//                 color: Colors.purple,
//               ),
//             ),
//           ],
//         ),
//       ),
//       itemCount: 250,
//     );
//   }
// }

// /// Demonstrates a [GridView] containing [CachedNetworkImage]
// class GridContent extends StatelessWidget {
//   const GridContent({super.key});

//   static ExamplePage createPage() {
//     return ExamplePage(Icons.grid_on, (context) => const GridContent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       itemCount: 250,
//       gridDelegate:
//           const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//       itemBuilder: (BuildContext context, int index) => CachedNetworkImage(
//         imageUrl: 'https://loremflickr.com/100/100/music?lock=$index',
//         placeholder: _loader,
//         errorWidget: _error,
//       ),
//     );
//   }

//   Widget _loader(BuildContext context, String url) {
//     return const Center(child: CircularProgressIndicator());
//   }

//   Widget _error(BuildContext context, String url, Object error) {
//     return const Center(child: Icon(Icons.error));
//   }
// }
