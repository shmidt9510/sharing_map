import 'package:sharing_map/path.dart';

import 'intro_screen.dart';

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

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/images/intro/intro_0.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/intro/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, color: MColors.primaryWhite);

    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
            color: MColors.primaryWhite),
        bodyTextStyle: bodyStyle,
        bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        pageColor: MColors.primaryGreen,
        imagePadding: EdgeInsets.zero,
        bodyFlex: 1,
        imageFlex: 2,
        safeArea: 1);
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: MColors.primaryGreen,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      // globalHeader: Align(
      //   alignment: Alignment.topRight,
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 16, right: 16),
      //       child: _buildImage('intro_0.png', 100),
      //     ),
      //   ),
      // ),
      // globalFooter: SizedBox(
      //   width: double.infinity,
      //   height: 60,
      //   child: ElevatedButton(
      //     child: const Text(
      //       'Let\'s go right away!',
      //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //     ),
      //     onPressed: () => _onIntroEnd(context),
      //   ),
      // ),
      pages: [
        // PageViewModel(
        //   title: "Full Screen Page",
        //   // body:
        //   //     "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
        //   bodyWidget: _buildImage('intro_0.png'),
        //   // decoration: pageDecoration.copyWith(
        //   //   contentMargin: const EdgeInsets.symmetric(horizontal: 16),
        //   //   fullScreen: true,
        //   //   bodyFlex: 2,
        //   //   imageFlex: 3,
        //   //   safeArea: 100,
        //   // ),
        // ),
        PageViewModel(
          title: "Поделись",
          body:
              "Не храни ненужные вещи - поделись ими с тем, кто в них нуждается",
          image: _buildImage('intro_1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Найди вещи",
          body: "Новые старые вещи можно найти в Sharing Map",
          image: _buildImage('intro_2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Отдавать вещи легко",
          body: "Отдавать вещи в шэринг мап легко",
          image: _buildImage('intro_3.png'),
          decoration: pageDecoration,
        ),

        // PageViewModel(
        //   title: "Another title page",
        //   body: "Another beautiful body text for this example onboarding",
        //   image: _buildImage('images/intro/intro_2.svg'),
        //   footer: ElevatedButton(
        //     onPressed: () {
        //       introKey.currentState?.animateScroll(0);
        //     },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.lightBlue,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8.0),
        //       ),
        //     ),
        //     child: const Text(
        //       'FooButton',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //   ),
        //   decoration: pageDecoration.copyWith(
        //     bodyFlex: 6,
        //     imageFlex: 6,
        //     safeArea: 80,
        //   ),
        // ),
        // PageViewModel(
        //   title: "Title of last page - reversed",
        //   bodyWidget: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text("Click on ", style: bodyStyle),
        //       Icon(Icons.edit),
        //       Text(" to edit a post", style: bodyStyle),
        //     ],
        //   ),
        //   decoration: pageDecoration.copyWith(
        //     bodyFlex: 2,
        //     imageFlex: 4,
        //     bodyAlignment: Alignment.bottomCenter,
        //     imageAlignment: Alignment.topCenter,
        //   ),
        //   image: _buildImage('images/intro/intro_3.svg'),
        //   reverse: true,
        // ),
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
