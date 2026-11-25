abstract class AdminProductsStates {}

class AdminProductsInitialState extends AdminProductsStates {}

class AdminProductsLoadingState extends AdminProductsStates {}

class AdminProductsSuccessState extends AdminProductsStates {}

class AdminProductsErrorState extends AdminProductsStates {
  final String error;
  AdminProductsErrorState(this.error);
}

class AdminProductSavingState extends AdminProductsStates {}

class AdminProductSavedState extends AdminProductsStates {}

class AdminProductSaveErrorState extends AdminProductsStates {
  final String error;
  AdminProductSaveErrorState(this.error);
}

class AdminProductDeletedState extends AdminProductsStates {}
