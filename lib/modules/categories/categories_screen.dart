import 'package:flutter/material.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_cubit.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_states.dart';
import 'package:shop_app/shared/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = ShopLayoutCubit.of(context);
    return BlocConsumer<ShopLayoutCubit, ShopLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) => cubit.categoriesModel == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: List.generate(
                cubit.categoriesModel?.data?.data?.length ?? 0,
                (index) {
                  final model = cubit.categoriesModel?.data?.data![index];
                  return Row(
                    children: [
                      Container(
                        height: 100.0,
                        width: 80,
                        child: Image.network(
                          model?.image ?? '',
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: null,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(model!.name!),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios),
                      SizedBox(width: 15)
                    ],
                  );
                },
              ),
            ),
    );
  }
}
