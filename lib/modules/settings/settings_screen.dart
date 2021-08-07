import 'package:flutter/material.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_cubit.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_states.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/shared/components/reuseable_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutStates>(
      listener: (context, state) {
        if (state is ShopLayoutLogoutState) {
          navigateToAndRemoveLast(context, loginRouteName);
        }
      },
      builder: (context, state) {
        final cubit = ShopLayoutCubit.of(context);
        nameController.text = cubit.userDataModel?.name ?? '';
        emailController.text = cubit.userDataModel?.email ?? '';
        phoneController.text = cubit.userDataModel?.phone ?? '';

        return cubit.userDataModel == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                      context: context,
                      label: 'name',
                      inputType: TextInputType.name,
                      controller: nameController,
                    ),
                    SizedBox(height: 20),
                    defaultFormField(
                      context: context,
                      label: 'email',
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    SizedBox(height: 20),
                    defaultFormField(
                      context: context,
                      label: 'phone',
                      inputType: TextInputType.phone,
                      controller: phoneController,
                    ),
                    Spacer(),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        child: cubit.logoutLoading ? CircularProgressIndicator() : Text('LOGOUT'),
                        onPressed: cubit.logoutLoading
                            ? null
                            : () {
                                cubit.logOutCubit();
                              },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        child: cubit.updateProfileLoading ? CircularProgressIndicator() : Text('Update profile'),
                        onPressed: cubit.updateProfileLoading
                            ? null
                            : () {
                                cubit.updateProfileCubit(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text,
                                );
                              },
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
