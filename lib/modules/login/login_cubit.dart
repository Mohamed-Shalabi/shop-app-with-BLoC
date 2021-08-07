import 'package:shop_app/modules/login/login_network.dart';
import 'package:shop_app/modules/login/login_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  var _isObscure = true;
  get isObscure => _isObscure;
  set isObscure(value) {
    _isObscure = value;
    emit(LoginPasswordObscureState());
  }

  static LoginCubit of(context) => BlocProvider.of(context);

  void loginFromCubit({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    await login(email, password).then((value) {
      emit(LoginSuccessfulState(value));
    }).catchError((error) {
      emit(LoginErrorState(error));
    });
  }

  void signupFromCubit({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(SignupLoadingState());
    await signup(name, email, password, phone).then((value) {
      emit(SignupSuccessfulState(value));
    }).catchError((error) {
      emit(SignupErrorState(error));
    });
  }
}
