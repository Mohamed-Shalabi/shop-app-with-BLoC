import 'package:dio/dio.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginPasswordObscureState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessfulState extends LoginStates {
  Response<dynamic> value;
  LoginSuccessfulState(this.value);
}

class LoginErrorState extends LoginStates {
  dynamic error;
  LoginErrorState(this.error);
}

class SignupLoadingState extends LoginStates {}

class SignupSuccessfulState extends LoginStates {
  Response<dynamic> value;
  SignupSuccessfulState(this.value);
}

class SignupErrorState extends LoginStates {
  dynamic error;
  SignupErrorState(this.error);
}
