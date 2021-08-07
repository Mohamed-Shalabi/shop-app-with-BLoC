import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/shared/local/CachHelper.dart';
import 'package:shop_app/shared/network/dio_helper.dart';

Future<Response> getHomeData() async {
  return await DioHelper.getData(
    path: 'home',
    token: CacheHelper.getData(key: 'token'),
  );
}

Future<Response> getCategories() async {
  return await DioHelper.getData(
    path: 'categories',
    token: CacheHelper.getData(key: 'token'),
  );
}

Future<Response> changeFavorite(int? id) async {
  return await DioHelper.postData(
    path: 'favorites',
    token: CacheHelper.getData(key: 'token'),
    data: FormData.fromMap({'product_id': id}),
  );
}

Future<Response> getFavorites() async {
  return await DioHelper.getData(
    path: 'favorites',
    token: CacheHelper.getData(key: 'token'),
  );
}

Future<Response> getProfile() async {
  return await DioHelper.getData(
    path: 'profile',
    token: CacheHelper.getData(key: 'token'),
  );
}

Future<Response> logOut() async {
  return await DioHelper.postData(
    path: 'logout',
    token: CacheHelper.getData(key: 'token'),
  );
}

Future<Response> updateProfile({
  required String name,
  required String email,
  required String phone,
}) async {
  return await DioHelper.putData(
    path: 'update-profile',
    token: CacheHelper.getData(key: 'token'),
    data: jsonEncode({'name': name, 'email': email, 'phone': phone}),
  );
}
