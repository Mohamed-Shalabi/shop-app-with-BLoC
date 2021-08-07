import 'package:flutter/material.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_states.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/shared/components/reuseable_components.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return ShopLayoutCubit()
          ..getHomeDataCubit()
          ..getCategoriesCubit()
          ..getProfileCubit();
      },
      child: BlocConsumer<ShopLayoutCubit, ShopLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ShopLayoutCubit.of(context);
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: Text('Softagy'),
              actions: [IconButton(onPressed: () => navigateTo(context, searchRouteName), icon: Icon(Icons.search))],
            ),
            body: cubit.page,
            bottomNavigationBar: BottomNavigationBar(
              items: cubit.items,
              currentIndex: cubit.currentIndex,
              onTap: (index) => cubit.navToIndex(index),
            ),
          );
        },
      ),
    );
  }
}
