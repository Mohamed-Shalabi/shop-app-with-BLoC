abstract class ShopLayoutStates {}

class ShopLayoutInitialState extends ShopLayoutStates {}

class ShopLayoutChangeNavState extends ShopLayoutStates {}

class ShopLayoutGetHomeDataState extends ShopLayoutStates {}

class ShopLayoutFailedGetHomeDataState extends ShopLayoutStates {}

class ShopLayoutGetCategoriesState extends ShopLayoutStates {}

class ShopLayoutFailedGetCategoriesState extends ShopLayoutStates {}

class ShopLayoutLoadingState extends ShopLayoutStates {}

class ShopLayoutChangeFavoriteState extends ShopLayoutStates {}

class ShopLayoutChangeFavoriteFailedState extends ShopLayoutStates {
  final String message;
  ShopLayoutChangeFavoriteFailedState(this.message);
}

class ShopLayoutGetFavoritesState extends ShopLayoutStates {}

class ShopLayoutGetFavoritesFailedState extends ShopLayoutStates {}

class ShopLayoutGetProfileState extends ShopLayoutStates {}

class ShopLayoutGetProfileFailedState extends ShopLayoutStates {}

class ShopLayoutLogoutState extends ShopLayoutStates {}

class ShopLayoutLogoutFailedState extends ShopLayoutStates {}

class ShopLayoutUpdateProfileState extends ShopLayoutStates {}

class ShopLayoutUpdateProfileFailedState extends ShopLayoutStates {
  final String message;
  ShopLayoutUpdateProfileFailedState(this.message);
}
