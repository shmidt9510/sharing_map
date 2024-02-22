import 'package:sharing_map/path.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:sharing_map/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    GoRouter.of(context).go(SMPath.start);
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/intro/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, color: MColors.white);

    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 28.0, fontWeight: FontWeight.w700, color: MColors.white),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: MColors.primaryGreen,
        imagePadding: EdgeInsets.zero,
        bodyFlex: 1,
        imageFlex: 2,
        safeArea: 50);
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: MColors.primaryGreen,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      pages: [
        PageViewModel(
          title: "Поделись",
          body: "Не выбрасывайте ненужные вещи, отдайте их тем, кому они нужны",
          image: _buildImage('intro_1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Найди вещи",
          body: "Не покупайте новые вещи - найдите их на SharingMap",
          image: _buildImage('intro_2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Отдавать вещи легко",
          body: "Отдавать и находить вещи на SharingMap - легко и просто",
          image: _buildImage('intro_3.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
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
}
