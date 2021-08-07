import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/home_model.dart';

class FavoritesModel {
  bool? status;
  String? message;
  FavoritesModelData? data;

  FavoritesModel.fromJson(Map<String, dynamic> json, List<ProductModel?>? products) {
    status = json['status'];
    message = json['message'];
    data = FavoritesModelData.fromJson(json['data'], products);
  }
}

class FavoritesModelData {
  int? currentPage;
  List<FavoritesModelDataData?>? data;
  FavoritesModelData.fromJson(Map<String, dynamic> json, List<ProductModel?>? products) {
    currentPage = json['current_page'];
    data = json['data']
        .map((element) {
          return FavoritesModelDataData.fromJson(element, products);
        })
        .cast<FavoritesModelDataData>()
        .toList();
  }
}

class FavoritesModelDataData {
  int? id;
  FavoritesModelDataDataProduct? product;
  FavoritesModelDataData.fromJson(Map<String, dynamic> json, List<ProductModel?>? products) {
    id = json['id'];
    product = FavoritesModelDataDataProduct.fromJson(json['product'], products);
  }
}

class FavoritesModelDataDataProduct {
  ProductModel? product;

  FavoritesModelDataDataProduct.fromJson(Map<String, dynamic> json, List<ProductModel?>? products) {
    final id = json['id'];
    product = products?.firstWhere((element) {
      return element?.id == id;
    });
  }

  FavoritesModelDataDataProduct.fromProduct(ProductModel productModel) {
    product = productModel;
  }
}
