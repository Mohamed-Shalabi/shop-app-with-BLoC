import 'dart:ffi';

import 'package:shop_app/layout/shop_layout/shop_layout_states.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/layout/shop_layout/shop_network.dart';
import 'package:shop_app/modules/home/home_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/local/CachHelper.dart';

class ShopLayoutCubit extends Cubit<ShopLayoutStates> {
  ShopLayoutCubit() : super(ShopLayoutInitialState());

  static ShopLayoutCubit of(context) => BlocProvider.of(context);

  final items = [
    BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
    BottomNavigationBarItem(label: 'Categories', icon: Icon(Icons.apps)),
    BottomNavigationBarItem(label: 'Favorites', icon: Icon(Icons.favorite)),
    BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.settings)),
  ];

  int currentIndex = 0;
  void navToIndex(int index) {
    currentIndex = index;
    emit(ShopLayoutChangeNavState());
  }

  final pages = [HomeScreen(), CategoriesScreen(), FavoritesScreen(), SettingsScreen()];

  get page => pages[currentIndex];

  HomeModel? homeData;
  Map<int?, bool?> favorites = {};
  Map<int?, bool?> favoritesLoading = {};
  void getHomeDataCubit() {
    emit(ShopLayoutLoadingState());
    getHomeData().then(
      (response) async {
        homeData = HomeModel.fromJson(response.data);
        homeData?.products?.forEach((element) => favorites.addAll({element?.id: element?.isInFavorites}));
        homeData?.products?.forEach((element) => favoritesLoading.addAll({element?.id: false}));
        print(homeData);
        getFavoritesCubit();
        emit(ShopLayoutGetHomeDataState());
      },
    ).catchError(
      (error) {
        emit(ShopLayoutFailedGetHomeDataState());
        print(error.toString());
      },
    );
  }

  CategoriesModel? categoriesModel;
  void getCategoriesCubit() {
    getCategories().then(
      (response) {
        categoriesModel = CategoriesModel.fromJson(response.data);
        print(categoriesModel);
        emit(ShopLayoutGetCategoriesState());
      },
    ).catchError(
      (error) {
        emit(ShopLayoutFailedGetCategoriesState());
        print(error.toString());
      },
    );
  }

  void changeFavoriteCubit(ProductModel model) async {
    favoritesLoading[model.id] = true;
    emit(ShopLayoutLoadingState());
    await changeFavorite(model.id).then((value) {
      final changeFavoriteModel = ChangeFavoriteModel.fromJson(value.data);
      if (changeFavoriteModel.status ?? false) {
        model.isInFavorites = !(model.isInFavorites!);
        favorites[model.id] = model.isInFavorites;
        favoritesLoading[model.id] = false;
        if (model.isInFavorites!) {
          favoriteProducts.add(notFavoriteProducts.where((element) => element?.product?.id == model.id).first);
          notFavoriteProducts.removeWhere((element) => element?.product?.id == model.id);
        } else {
          favoriteProducts.removeWhere((element) {
            notFavoriteProducts.add(element);
            return element?.product?.id == model.id;
          });
        }
        emit(ShopLayoutChangeFavoriteState());
      } else {
        favoritesLoading[model.id] = false;
        emit(ShopLayoutChangeFavoriteFailedState(changeFavoriteModel.message ?? ''));
      }
    }).catchError((e, s) {
      favoritesLoading[model.id] = false;
      emit(ShopLayoutChangeFavoriteFailedState('An Error Occurred'));
      print(e);
      print(s);
    });
  }

  List<FavoritesModelDataDataProduct?> favoriteProducts = [];
  List<FavoritesModelDataDataProduct?> notFavoriteProducts = [];
  void getFavoritesCubit() {
    emit(ShopLayoutLoadingState());
    getFavorites().then((response) {
      final favoritesModel = FavoritesModel.fromJson(response.data, homeData?.products);
      print('status: ${favoritesModel.status}');
      if (favoritesModel.status ?? false) {
        favoritesModel.data?.data?.forEach((element) {
          favoriteProducts.add(element?.product);
        });
        homeData?.products?.forEach((element) {
          if (!(element!.isInFavorites!)) {
            notFavoriteProducts.add(FavoritesModelDataDataProduct.fromProduct(element));
          }
        });
        emit(ShopLayoutGetFavoritesState());
      } else {
        emit(ShopLayoutGetFavoritesFailedState());
      }
    }).catchError((e, s) {
      print(e.toString());
      print(s.toString());
      emit(ShopLayoutGetFavoritesFailedState());
    });
  }

  UserDataModel? userDataModel;
  void getProfileCubit() {
    emit(ShopLayoutLoadingState());
    getProfile().then(
      (response) {
        final loginModel = LoginModel.fromJson(response.data);
        userDataModel = loginModel.data;
        if (loginModel.status ?? false) {
          emit(ShopLayoutGetProfileState());
        } else {
          emit(ShopLayoutGetProfileFailedState());
        }
      },
    ).catchError(
      (e, s) {
        print(e.toString());
        print(s.toString());
        emit(ShopLayoutGetProfileFailedState());
      },
    );
  }

  var logoutLoading = false;
  void logOutCubit() {
    logoutLoading = true;
    emit(ShopLayoutLoadingState());
    logOut().then(
      (response) async {
        if (response.data['status']) {
          await CacheHelper.saveData(key: 'token', value: '');
          logoutLoading = false;
          emit(ShopLayoutLogoutState());
        } else {
          print(response.data['message']);
          logoutLoading = false;
          emit(ShopLayoutLogoutFailedState());
        }
      },
    ).catchError(
      (e, s) {
        print(e);
        print(s);
        logoutLoading = false;
        emit(ShopLayoutLogoutFailedState());
      },
    );
  }

  bool updateProfileLoading = false;
  void updateProfileCubit({required String name, required String email, required String phone}) {
    updateProfileLoading = true;
    emit(ShopLayoutLoadingState());
    updateProfile(name: name, email: email, phone: phone).then(
      (response) {
        final model = LoginModel.fromJson(response.data);
        if (model.status ?? false) {
          final user = model.data;
          userDataModel = user;
          emit(ShopLayoutUpdateProfileState());
        } else {
          print(model.message);
          emit(ShopLayoutUpdateProfileFailedState(model.message ?? 'An error occurred'));
        }
        updateProfileLoading = false;
      },
    ).catchError(
      (e, s) {
        print(e);
        print(s);
        updateProfileLoading = false;
        emit(ShopLayoutUpdateProfileFailedState(e.toString()));
      },
    );
  }
}
