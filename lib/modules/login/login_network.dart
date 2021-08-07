import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/shared/network/dio_helper.dart';
import 'package:dio/dio.dart';

Future<Response> login(String email, String password) async {
  final response = await DioHelper.postData(
    path: 'login',
    data: {
      "email": email,
      "password": password,
    },
    onReceiveProgress: (int count, int total) {
      print(total / count);
    },
  );
  return response;
}

Future<Response> signup(String name, String email, String password, String phone) async {
  final response = await DioHelper.postData(
    path: 'register',
    data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    },
  );
  return response;
}

LoginModel parseLogin(Map<String, dynamic> json) {
  return LoginModel.fromJson(json);
}
