import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/controllers/forget_password_cubit/forget_password_states.dart';
import 'package:volt/core/mangers/toast.dart';
import 'package:volt/core/network/remote/api_constants.dart';
import 'package:volt/core/network/remote/store/dio_helper.dart';
import 'package:volt/users/models/forget_password_model.dart';
class ForgetPasswordCubit extends Cubit<ForgetPasswordStates>{
  ForgetPasswordCubit() : super(ForgetPasswordInitStates());
  static ForgetPasswordCubit get(context)=>BlocProvider.of(context);
  ForgetPasswordModel? forgetPasswordModel;
  void resetPassword(nationalId,newPassword){
    emit(ResetPasswordLoadingState());
    DioHelperStore.postData(url:ApiConstants.forgetPasswordApi, data:{
      "nationalId": nationalId,
      "newPassword": newPassword,
    }).then((value){
     forgetPasswordModel = ForgetPasswordModel.fromJson(value.data);
     showToast(forgetPasswordModel!.message!, ToastStates.SUCCESS);
      emit(ResetPasswordDone());
    }).catchError((error){
      print(error.toString());
      showToast('User Not Found', ToastStates.ERROR);
      emit(ErrorResetPassword());
    });
  }
}