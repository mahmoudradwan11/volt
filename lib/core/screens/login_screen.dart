import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel_core.dart';
import 'package:volt/core/controllers/login_cubit/login_cubit.dart';
import 'package:volt/core/controllers/login_cubit/login_states.dart';
import 'package:volt/core/mangers/reg/reg_exp.dart';
import 'package:volt/core/mangers/toast.dart';
import 'package:volt/core/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
      if (state is LoginSuccessState) {
        if (state.model.status == "success") {
          print(state.model.message);
          print(state.model.user!.token);
          CacheHelper.saveData(
              key: 'userId', value: state.model.user!.nationalId)
              .then((value) {
            nationalId = state.model.user!.nationalId;
          });
          CacheHelper.saveData(key: 'token', value: state.model.user!.token)
              .then((value) {
            token = state.model.user!.token;
            showToast('${state.model.message}', ToastStates.SUCCESS);
            if (state.model.user!.nationalId == adminId) {
             // navigateAndFinishThisScreen(context, const AdminHomeScreen());
            } else {
             // ElktraCubit.get(context).currentHomeScreenIndex=0;
              Navigator.pushNamed(context,AppRoutes.home);
            }
          });
        } else {
          print(state.model.message);
        }
      }
    }, builder: (context, state) {
      LoginCubit cubit = LoginCubit.get(context);
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.loginAndRegisterBackground,),
                fit: BoxFit.cover
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        child: Image(image: AssetImage(AppImages.splash,),
                          fit: BoxFit.cover,),
                      ),
                    ),
                    Center(
                      child: Text('volt'.toUpperCase(),
                        style: TextStyle(color: AppColors.scaffoldBackGroundColor,
                          fontFamily: 'Montserrat',
                          fontSize: AppFontsSize.fontSize50,),),
                    ),
                    Center(
                      child: Text('Power of World'.toUpperCase(),
                        style: TextStyle(color: Colors.indigo,
                          fontFamily: 'Jannah',
                          fontSize: AppFontsSize.fontSize20,),),
                    ),
                    Row(
                      children: [
                        Text('Welcome back',
                          style: TextStyle(
                            color: AppColors.scaffoldBackGroundColor,
                            fontFamily: 'Montserrat',
                            fontSize: AppFontsSize.fontSize20,),),
                        Image(image: AssetImage(AppImages.splash), width: 30)
                      ],
                    ),
                    Text('Login to continue to your account',
                      style: TextStyle(color: Colors.grey,
                        fontFamily: 'Montserrat',
                        fontSize: AppFontsSize.fontSize15,),),
                    SizedBox(height: 20,),
                    DefaultFieldForm(controller: emailController,
                      keyboard: TextInputType.emailAddress,
                      valid: (value) {},
                      label: 'Email',
                      hint: 'Enter Your Email',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w100),
                      labelStyle: TextStyle(
                        color: AppColors.scaffoldBackGroundColor,
                        fontWeight: FontWeight.w100,),
                      prefix: IconBroken.Message,
                    ),
                    SizedBox(height: AppValuesForWAndH.height2,),
                    DefaultFieldForm(controller: passwordController,
                      keyboard: TextInputType.visiblePassword,
                      valid: (value) {},
                      label: 'Password',
                      hint: 'Enter Your Password',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w100),
                      labelStyle: TextStyle(
                        color: AppColors.scaffoldBackGroundColor,
                        fontWeight: FontWeight.w100,),
                      prefix: IconBroken.Lock,
                      suffix: IconBroken.Hide,
                    ),
                    Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: MaterialButton(onPressed: () {
                          //  navigateToNextScreen(context, ForgetPasswordScreen());
                        }, child: Text('Forget Password ?', style: TextStyle(
                            color: Colors.indigo),),)),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultButton(
                        backgroundColor: Colors.indigo.withOpacity(0.5),
                        borderColor: Colors.transparent,
                        buttonWidget: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        function: () {
                          if (formKey.currentState!.validate()) {
                            if (Exp.isEmailValid(emailController.text)) {
                              cubit.loginUser(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                            else {
                              showToast('Please Enter Valid Email',
                                  ToastStates.WARNING);
                            }
                          }
                        }
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          Text('I don\'t Have account!',
                              style: TextStyle(color: Colors.grey)),
                          MaterialButton(onPressed: () {
                            // navigateAndReplace(context, Routes.registerRoute);
                          },
                              child: Text('Create Account',
                                style: TextStyle(
                                    color: AppColors.scaffoldBackGroundColor),))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    );
  }
}
