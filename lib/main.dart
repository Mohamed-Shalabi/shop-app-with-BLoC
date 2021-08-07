import 'package:shop_app/layout/shop_layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/onboarding_screen/onboarding_screen.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/modules/signup/signup_screen.dart';
import 'package:shop_app/shared/components/shared_preferences_keys.dart';
import 'package:shop_app/shared/local/CachHelper.dart';
import 'package:shop_app/shared/network/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();

  final token = CacheHelper.getData(key: tokenKey);
  print('token: $token');
  final skipOnBoarding = CacheHelper.getData(key: onBoardingSkipKey);

  runApp(
    MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: token != null && token.isNotEmpty
          ? shopRouteName
          : skipOnBoarding == true
              ? loginRouteName
              : onBoardingRouteName,
      routes: {
        onBoardingRouteName: (context) => OnBoardingScreen(),
        loginRouteName: (context) => LoginScreen(),
        signupRouteName: (context) => SignupScreen(),
        shopRouteName: (context) => ShopLayout(),
        searchRouteName: (context) => SearchScreen(),
      },
    ),
  );
}

final onBoardingRouteName = '/onBoarding';
final loginRouteName = '/login';
final signupRouteName = '/signup';
final shopRouteName = '/shop';
final searchRouteName = '/shop/search';
