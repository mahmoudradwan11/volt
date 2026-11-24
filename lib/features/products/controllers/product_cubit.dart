import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/core/constants/toast.dart';
import 'package:volt/features/products/controllers/product_states.dart';
import 'package:volt/features/products/models/product_model.dart';
import 'package:volt/features/products/models/review_model.dart';

class ProductCubit extends Cubit<ProductStates>{
  ProductCubit() : super(ProductInitialState());
  static ProductCubit get(context) => BlocProvider.of(context);
  ProductModel? productModel;
  void getProducts(String category){
    emit(ProductLoadingState());
    DioHelperStore.getData(url:'${ApiConstants.homeProductsApi}$category', data: {
      "nationalId": nationalId,
    }).then((value) {
      productModel = ProductModel.fromJson(value.data);
      print(productModel!.phoneNewProduct?.length);
      print(productModel!.phoneUsedProduct?.length);
      emit(GetProductStates());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorProductStates());
    });
  }
  void addReview(productId, comment, rate) {
    DioHelperStore.postData(url: 'https://elwekala.onrender.com/review', data: {
      "user": nationalId,
      "productId": productId,
      "title": "Good",
      "comment": comment,
      "rating": rate
    }).then((value) {
      showToast('Review Added', ToastStates.SUCCESS);
      getAllReviews(productId);
      emit(AddReview());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorAddReview());
      showToast('Rating Must Not More Than 5', ToastStates.ERROR);
    });
  }

  ReviewModel? reviewModel;

  void getAllReviews(productId) {
    DioHelperStore.getData(
        url: 'https://elwekala.onrender.com/review/allreviews/$productId')
        .then((value) {
      reviewModel = ReviewModel.fromJson(value.data);
      print('Reviews = ${reviewModel!.reviews?.length}');
      emit(GetAllReviews());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetAllReviews());
    });
  }
  void deleteReview(reviewId,productId){
    DioHelperStore.delData(url:'https://elwekala.onrender.com/review/$reviewId',).then((value){
      emit(DeleteReview());
      getAllReviews(productId);
    }).catchError((error){
      print(error.toString());
      emit(ErrorDeleteReview());
    });
  }
}