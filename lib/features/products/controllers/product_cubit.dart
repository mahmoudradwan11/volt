import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/features/products/controllers/product_states.dart';
import 'package:volt/features/products/models/product_model.dart';

class ProductCubit extends Cubit<ProductStates>{
  ProductCubit() : super(ProductInitialState());
  static ProductCubit get(context) => BlocProvider.of(context);
  ProductModel? productModel;
  void getProducts(category){
    DioHelperStore.getData(url:'${ApiConstants.homeProductsApi}$category', data: {
      "nationalId": nationalId,
    }).then((value) {
      productModel = ProductModel.fromJson(value.data);
      print(productModel!.phoneNewProduct!.length);
      print(productModel!.phoneUsedProduct!.length);
      emit(GetProductStates());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorProductStates());
    });
  }
}