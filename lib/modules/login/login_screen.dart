import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/modules/login/login_cubit.dart';
import 'package:shop_app/modules/login/login_network.dart';
import 'package:shop_app/modules/login/login_states.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/components/reuseable_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/components/shared_preferences_keys.dart';
import 'package:shop_app/shared/local/CachHelper.dart';
import 'package:shop_app/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return LoginCubit();
      },
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (BuildContext context, state) {
          if (state is LoginSuccessfulState) {
            final value = state.value;
            print(value);
            if (value.statusCode == 200) {
              final loginModel = parseLogin(value.data);
              if (loginModel.status == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Welcome ${loginModel.data?.name}!!')),
                );
                CacheHelper.saveData(key: tokenKey, value: loginModel.data?.token);
                navigateToAndRemoveLast(context, shopRouteName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loginModel.message ?? 'an error occurred')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('an error occurred')),
              );
            }
          }
          if (state is LoginErrorState) {
            print(state.error.toString());
          }
        },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  child: buildTopTitle(context),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'LOGIN',
                              style: getTextTheme(context).headline4?.copyWith(color: Colors.black),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Login now to browse our hot offers',
                              style: getTextTheme(context).subtitle2,
                            ),
                            SizedBox(height: 50),
                            buildEmailForm(context),
                            SizedBox(height: 20),
                            buildPasswordForm(context),
                            SizedBox(height: 20),
                            buildLoginButton(context, state),
                            SizedBox(height: 20.0),
                            buildSignupText(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  RichText buildSignupText(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: getTextTheme(context).bodyText2,
        text: "Don't have an account? ",
        children: <TextSpan>[
          TextSpan(
            text: 'SIGN UP',
            style: getTextTheme(context).bodyText1?.copyWith(color: defaultColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                navigateTo(context, signupRouteName);
              },
          ),
        ],
      ),
    );
  }

  Container buildLoginButton(BuildContext context, state) {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        onPressed: state is LoginLoadingState
            ? null
            : () {
                if (formKey.currentState?.validate() ?? false) {
                  LoginCubit.of(context).loginFromCubit(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                }
              },
        child: state is LoginLoadingState ? CircularProgressIndicator(color: Colors.white) : Text('LOGIN'),
      ),
    );
  }

  Widget buildPasswordForm(BuildContext context) {
    return defaultFormField(
      context: context,
      label: 'password',
      inputType: TextInputType.visiblePassword,
      prefix: Icons.lock_outlined,
      obscure: LoginCubit.of(context).isObscure,
      controller: passwordController,
      suffix: LoginCubit.of(context).isObscure ? Icons.visibility : Icons.visibility_off,
      onSuffixTapped: () {
        LoginCubit.of(context).isObscure = !LoginCubit.of(context).isObscure;
      },
    );
  }

  Widget buildEmailForm(BuildContext context) {
    return defaultFormField(
      context: context,
      label: 'email',
      inputType: TextInputType.emailAddress,
      prefix: Icons.email_outlined,
      controller: emailController,
      validator: (input) {
        if (RegExp(emailRegex).hasMatch(input ?? '')) {
          return null;
        }
        return 'write a correct email address';
      },
    );
  }

  Stack buildTopTitle(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          child: CustomPaint(
            painter: CurvePainter(),
          ),
        ),
        Positioned(
          bottom: 60,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'SOFTAGY',
              textAlign: TextAlign.center,
              style: getTextTheme(context).headline6?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = defaultColor;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
