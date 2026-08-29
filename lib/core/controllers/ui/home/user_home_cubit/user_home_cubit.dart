import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/controllers/ui/home/user_home_cubit/user_home_states.dart';

class UserHomeCubit extends Cubit<UserHomeStates> {
  UserHomeCubit() : super(InitialState());

  static UserHomeCubit get(context) => BlocProvider.of(context);
  int currentScreenIndex = 0;
  void changeIndex(int index) {
    currentScreenIndex = index;
    emit(ChangeScreenIndex());
  }
}