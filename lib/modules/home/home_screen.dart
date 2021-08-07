import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_cubit.dart';
import 'package:shop_app/layout/shop_layout/shop_layout_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/reuseable_components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLayoutCubit, ShopLayoutStates>(
      listener: (context, state) {
        if (state is ShopLayoutChangeFavoriteFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = ShopLayoutCubit.of(context);
        return cubit.homeData == null || cubit.categoriesModel == null
            ? Container(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  buildCarouselSlider(cubit),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Categories',
                      style: getTextTheme(context).headline6,
                    ),
                  ),
                  Container(
                    height: 100,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: cubit.categoriesModel?.data?.data?.map(
                            (model) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.33,
                                height: 80,
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
                              );
                            },
                          ).toList() ??
                          [],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Our New Products',
                      style: getTextTheme(context).headline6,
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 1 / 1.5,
                    children: cubit.homeData!.products
                            ?.map(
                              (e) => buildProduct(e!, context),
                            )
                            .toList() ??
                        [Container()],
                  ),
                ],
              );
      },
    );
  }

  CarouselSlider buildCarouselSlider(ShopLayoutCubit cubit) {
    return CarouselSlider(
      items: cubit.homeData?.banners?.map(
        (e) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Image.network(
              e!.image!,
              fit: BoxFit.fitWidth,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: null,
                  ),
                );
              },
            ),
          );
        },
      ).toList(),
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(seconds: 1),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildProduct(ProductModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 2.8,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      model.image!,
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
                    model.discount == 0
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
                model.name ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: getTextTheme(context).bodyText1,
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    '${model.price}',
                    style: getTextTheme(context).bodyText2?.copyWith(color: defaultColor),
                  ),
                  SizedBox(width: 10),
                  model.discount == 0
                      ? SizedBox()
                      : Text(
                          '${model.oldPrice}',
                          style: getTextTheme(context)
                              .caption
                              ?.copyWith(decoration: TextDecoration.lineThrough, fontWeight: FontWeight.bold),
                        ),
                  Spacer(),
                  IconButton(
                    onPressed: ShopLayoutCubit.of(context).favoritesLoading[model.id] ?? false
                        ? null
                        : () {
                            ShopLayoutCubit.of(context).changeFavoriteCubit(model);
                          },
                    icon: ShopLayoutCubit.of(context).favoritesLoading[model.id] ?? false
                        ? Container(width: 24, height: 24, child: CircularProgressIndicator())
                        : ShopLayoutCubit.of(context).favorites[model.id] ?? false
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
    );
  }
}
