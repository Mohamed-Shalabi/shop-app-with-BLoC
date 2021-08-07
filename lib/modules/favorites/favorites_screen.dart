import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_cubit.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_states.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/reuseable_components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ShopLayoutCubit.of(context);
        return cubit.favorites.length == 0
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: ListView(
                  children: List.generate(
                      cubit.favoriteProducts.length, (index) => buildProduct(cubit.favoriteProducts[index]?.product, context)),
                ),
              );
      },
    );
  }

  Widget buildProduct(ProductModel? model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 300,
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        model?.image ?? '',
                        fit: BoxFit.contain,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: null,
                            ),
                          );
                        },
                      ),
                      model?.discount == 0
                          ? SizedBox()
                          : Positioned(
                              top: 0.0,
                              left: 0.0,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                color: Colors.red,
                                child: Text(
                                  'DISCOUNT',
                                  style: getTextTheme(context).caption?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  model?.name ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: getTextTheme(context).bodyText1,
                ),
                Spacer(),
                Row(
                  children: [
                    Text(
                      '${model?.price}',
                      style: getTextTheme(context).bodyText2?.copyWith(color: defaultColor),
                    ),
                    SizedBox(width: 10),
                    model?.discount == 0
                        ? SizedBox()
                        : Text(
                            '${model?.oldPrice}',
                            style: getTextTheme(context)
                                .caption
                                ?.copyWith(decoration: TextDecoration.lineThrough, fontWeight: FontWeight.bold),
                          ),
                    Spacer(),
                    IconButton(
                      onPressed: ShopLayoutCubit.of(context).favoritesLoading[model?.id] ?? false
                          ? null
                          : () {
                              if (model != null) {
                                ShopLayoutCubit.of(context).changeFavoriteCubit(model);
                              }
                            },
                      icon: ShopLayoutCubit.of(context).favoritesLoading[model?.id] ?? false
                          ? Container(width: 24, height: 24, child: CircularProgressIndicator())
                          : ShopLayoutCubit.of(context).favorites[model?.id] ?? false
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_border),
                      padding: EdgeInsets.zero,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
