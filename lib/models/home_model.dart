class HomeModel {
  bool? status;
  List<BannerModel?>? banners;
  List<ProductModel?>? products;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    banners = [];
    products = [];
    try {
      for (var jsonObject in json['data']['banners']) {
        banners?.add(BannerModel.fromJson(jsonObject));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);
    }
    try {
      for (var jsonObject in json['data']['products']) {
        products?.add(ProductModel.fromJson(jsonObject));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class BannerModel {
  int? id;
  String? image;
  CategoryModel? category;
  ProductModel? product;

  BannerModel.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    image = json?['image'];
    category = CategoryModel.fromJson(json?['category']);
    product = ProductModel.fromJson(json?['product']);
  }
}

class CategoryModel {
  int? id;
  String? image;
  String? name;

  CategoryModel.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    image = json?['image'];
    name = json?['name'];
  }
}

class ProductModel {
  int? id;
  double? price;
  double? oldPrice;
  double? discount;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  List<dynamic>? _tempImages;
  bool? isInFavorites;
  bool? isInCart;

  ProductModel(
    this.id,
    this.price,
    this.oldPrice,
    this.discount,
    this.image,
    this.name,
    this.description,
    this.images,
    this._tempImages,
    this.isInFavorites,
    this.isInCart,
  );

  ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    id = json['id'];
    price = double.parse(json['price'].toString());
    oldPrice = double.parse(json['old_price'].toString());
    discount = double.parse(json['discount'].toString());
    image = json['image'];
    name = json['name'];
    description = json['description'];
    _tempImages = json['images'];
    isInFavorites = json['in_favorites'];
    isInCart = json['in_cart'];

    images = _tempImages?.map((e) => e.toString()).toList();
  }
}
