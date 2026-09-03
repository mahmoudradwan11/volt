import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:volt/core/controllers/ui/home/user_home_cubit/user_home_states.dart';
import 'package:volt/core/lists/home.dart';

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
      return LinearGradient(
          colors: [HexColor('#7832A3'), HexColor('##07094D')]);
    } else {
      return LinearGradient(colors: [
        HexColor('#E6E7E8'),
        HexColor('#E6E7E8'),
      ]);
    }
    }
  }