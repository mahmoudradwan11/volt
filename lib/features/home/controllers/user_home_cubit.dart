import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:volt/features/home/controllers/user_home_states.dart';
import 'package:volt/features/products/data/product_cate_list.dart';

class UserHomeCubit extends Cubit<UserHomeStates> {
  UserHomeCubit() : super(InitialState());

  static UserHomeCubit get(context) => BlocProvider.of(context);
  int currentScreenIndex = 0;
  void changeScreenIndex(int index) {
    currentScreenIndex = index;
    emit(ChangeScreenIndex());
  }
  int currentCategoryIndex = 0;
  void changeCategoryIndex(index){
    currentCategoryIndex = index;
    emit(ChangeCurrentCategoryIndex());
  }
   chooseCategoryColor(index){ // 0
    if(userHomeCateModel[index].id == currentCategoryIndex){
      return HexColor('#603FF8');
    } else {
      return  HexColor('#0E172E');
    }
    }
  }