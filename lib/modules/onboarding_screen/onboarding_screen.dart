import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/shared/components/reuseable_components.dart';
import 'package:shop_app/shared/components/shared_preferences_keys.dart';
import 'package:shop_app/shared/local/CachHelper.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pages = <PageModel>[
    PageModel(image: 'assets/images/boarding.png', title: 'Onboarding title 1', body: 'Onboarding body 1'),
    PageModel(image: 'assets/images/boarding.png', title: 'Onboarding title 2', body: 'Onboarding body 2'),
    PageModel(image: 'assets/images/boarding.png', title: 'Onboarding title 3', body: 'Onboarding body 3'),
  ];

  final pageController = PageController();
  var currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              navigateToLoginScreen(context);
            },
            child: Text('SKIP'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward_ios_rounded),
        onPressed: () {
          if (currentPage == pages.length - 1) {
            navigateToLoginScreen(context);
          } else {
            pageController.nextPage(duration: Duration(milliseconds: 750), curve: Curves.fastLinearToSlowEaseIn);
          }
        },
      ),
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildPage(context, pages[index]);
                    },
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      currentPage = index;
                    },
                  ),
                ),
                SizedBox(height: 50),
                SmoothPageIndicator(
                  count: pages.length,
                  controller: pageController,
                  effect: WormEffect(
                    activeDotColor: defaultColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildPage(
    BuildContext context,
    PageModel pageModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Image.asset(pageModel.image)),
        SizedBox(height: 30.0),
        Text(
          pageModel.title,
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: 20.0),
        Text(
          pageModel.body,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  void navigateToLoginScreen(context) {
    CacheHelper.saveData(key: onBoardingSkipKey, value: true);
    navigateToAndRemoveLast(context, loginRouteName);
  }
}

class PageModel {
  final String image;
  final String title;
  final String body;

  PageModel({required this.image, required this.title, required this.body});
}
