// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shop_app/main.dart';
import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/layout/shop_layout/shop_network.dart';
import 'package:shop_app/shared/network/dio_helper.dart';

void main() async {
  DioHelper.init();

  final responseHome = await DioHelper.getData(
    path: 'home',
    token: '0V8xzMKb62noGur12FHeQXryj4Ydp8K0qQ2Y5gHdFGbqc89EICzie8MKDe8JbMt9ThYyXv',
  );

  final products = HomeModel.fromJson(responseHome.data).products;

  final response = await DioHelper.getData(
    path: 'favorites',
    token: '0V8xzMKb62noGur12FHeQXryj4Ydp8K0qQ2Y5gHdFGbqc89EICzie8MKDe8JbMt9ThYyXv',
  );
  final favoritesModel = FavoritesModel.fromJson(response.data, products);
  if (favoritesModel.status ?? false) {
    favoritesModel.data?.data?.forEach((element) {
      print(element!.product!.product);
    });
  }
}
