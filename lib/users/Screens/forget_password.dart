import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel_core.dart';
import 'package:volt/core/controllers/forget_password_cubit/forget_password_cubit.dart';
import 'package:volt/core/controllers/forget_password_cubit/forget_password_states.dart';
import 'package:volt/core/mangers/reg/reg_exp.dart';
import 'package:volt/core/mangers/toast.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  var nationalIDController = TextEditingController();
  var newPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ForgetPasswordCubit cubit = ForgetPasswordCubit.get(context);
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.loginAndRegisterBackground),
                fit: BoxFit.cover,
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
                          child: Image(
                            image: AssetImage(AppImages.splash),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'volt'.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.scaffoldBackGroundColor,
                            fontFamily: 'Montserrat',
                            fontSize: AppFontsSize.fontSize50,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Power of World'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.indigo,
                            fontFamily: 'Jannah',
                            fontSize: AppFontsSize.fontSize20,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Forget Password',
                            style: TextStyle(
                              color: AppColors.scaffoldBackGroundColor,
                              fontFamily: 'Montserrat',
                              fontSize: AppFontsSize.fontSize20,
                            ),
                          ),
                          Image(image: AssetImage(AppImages.splash), width: 30),
                        ],
                      ),
                      Text(
                        'Please enter your data to continue',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Montserrat',
                          fontSize: AppFontsSize.fontSize15,
                        ),
                      ),
                      SizedBox(height: AppValuesForWAndH.height2),
                      DefaultFieldForm(
                        controller: nationalIDController,
                        keyboard: TextInputType.visiblePassword,
                        hint: 'NationalID',
                        label: 'NationalID',
                        valid: (value) {
                          if (value.isEmpty) {
                            return 'Enter Your NationalID';
                          }
                          return null;
                        },
                        labelStyle: TextStyle(
                          color: AppColors.scaffoldBackGroundColor,
                          fontWeight: FontWeight.w100,
                        ),
                        prefix: IconBroken.Ticket,
                      ),
                      SizedBox(height: AppValuesForWAndH.height2),
                      DefaultFieldForm(
                        controller: newPasswordController,
                        keyboard: TextInputType.visiblePassword,
                        hint: 'New Password',
                        label: 'New Password',
                        valid: (value) {
                          if (value.isEmpty) {
                            return 'Enter New Password';
                          }
                          return null;
                        },
                        labelStyle: TextStyle(
                          color: AppColors.scaffoldBackGroundColor,
                          fontWeight: FontWeight.w100,
                        ),
                        prefix: IconBroken.Lock,
                      ),
                      const SizedBox(height: 50),
                      DefaultButton(
                        backgroundColor: Colors.indigo.withOpacity(0.5),
                        borderColor: Colors.transparent,
                        buttonWidget: Text(
                          'Reset',
                          style: TextStyle(
                            color: AppColors.scaffoldBackGroundColor,
                          ),
                        ),
                        function: () {
                          if (formKey.currentState!.validate()) {
                            if (Exp.isNationalValid(
                              nationalIDController.text,
                            )) {
                              cubit.resetPassword(
                                nationalIDController.text,
                                newPasswordController.text,
                              );
                              Navigator.pushNamed(context, AppRoutes.login);
                            } else {
                              showToast(
                                'Please Enter Valid National ID',
                                ToastStates.WARNING,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
