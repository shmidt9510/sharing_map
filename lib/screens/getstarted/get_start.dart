import 'package:get/get.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:sharing_map/theme.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sharing_map/utils/init_path.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    GoRouter.of(context).go(await checkInitPath());
  }

  Widget _buildImage(String assetName, {double width = 350}) {
    return Image.asset('assets/images/intro/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    double width = context.width * 0.8;
    const bodyStyle = TextStyle(fontSize: 19.0, color: MColors.white);

    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 28.0, fontWeight: FontWeight.w700, color: MColors.white),
        bodyTextStyle: bodyStyle,
        // bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: MColors.primaryGreen,
        imagePadding: EdgeInsets.zero,
        bodyFlex: 1,
        imageFlex: 1,
        safeArea: 10);
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: MColors.primaryGreen,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      rawPages: [
        _getScreen(
            context,
            "Не выбрасывайте ненужные вещи, отдайте их тем, кому они нужны",
            "intro_1.png"),
        _getScreen(
            context,
            "Не покупайте новые вещи – найдите их на SharingMap",
            "intro_2.png"),
        _getScreen(
            context,
            "Отдавать и находить вещи на SharingMap легко и удобно",
            "intro_3.png"),
        _getScreen(context, "Общайтесь на SharingMap с замечательными людьми",
            "intro_4.png"),
      ],
      onDone: () async => _onIntroEnd(context),
      onSkip: () async => _onIntroEnd(context),
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back, color: MColors.secondaryGreen),
      skip: const Text('Пропустить',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: MColors.secondaryGreen)),
      next: const Icon(
        Icons.arrow_forward,
        color: MColors.secondaryGreen,
      ),
      done: const Text('Ок',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: MColors.secondaryGreen)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: MColors.secondaryGreen,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: MColors.primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _getScreen(BuildContext build, String text, String assetName) {
    return SizedBox(
      height: context.height / 2,
      child: Column(
        children: [
          SizedBox(
              height: context.height * 0.7,
              child: Image.asset('assets/images/intro/$assetName')),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: Text(text,
                  style: getBigTextStyle()
                      .copyWith(color: MColors.white, fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }
}
