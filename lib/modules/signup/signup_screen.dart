import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/modules/login/login_cubit.dart';
import 'package:shop_app/modules/login/login_network.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/login/login_states.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/components/reuseable_components.dart';
import 'package:shop_app/shared/components/shared_preferences_keys.dart';
import 'package:shop_app/shared/local/CachHelper.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return LoginCubit();
      },
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is SignupSuccessfulState) {
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
          if (state is SignupErrorState) {
            print(state.error.toString());
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  buildTopTitle(context),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'SIGNUP',
                            style: getTextTheme(context).headline4?.copyWith(color: Colors.black),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Login now to browse our hot offers',
                            style: getTextTheme(context).subtitle2,
                          ),
                          SizedBox(height: 50),
                          buildNameForm(context),
                          SizedBox(height: 20),
                          buildEmailForm(context),
                          SizedBox(height: 20),
                          buildPasswordForm(context),
                          SizedBox(height: 20),
                          buildPhoneForm(context),
                          SizedBox(height: 20),
                          buildSignupButton(context, state),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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

  Container buildSignupButton(BuildContext context, state) {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        onPressed: state is LoginLoadingState
            ? null
            : () {
                if (formKey.currentState?.validate() ?? false) {
                  LoginCubit.of(context).signupFromCubit(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                    phone: phoneController.text,
                  );
                }
              },
        child: state is SignupLoadingState ? CircularProgressIndicator(color: Colors.white) : Text('SIGNUP'),
      ),
    );
  }

  Widget buildNameForm(BuildContext context) {
    return defaultFormField(
      context: context,
      label: 'name',
      inputType: TextInputType.name,
      prefix: Icons.person_outline_outlined,
      controller: nameController,
    );
  }

  Widget buildPhoneForm(BuildContext context) {
    return defaultFormField(
      context: context,
      label: 'phone',
      inputType: TextInputType.phone,
      prefix: Icons.phone_outlined,
      controller: phoneController,
    );
  }
}
