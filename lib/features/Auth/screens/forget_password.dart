import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/Widgets/text_form_feild.dart';
import 'package:volt/core/barrel/barrel_core.dart';
import 'package:volt/core/utils/reg_exp.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  var nationalIDController = TextEditingController();
  var newPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordStates>(
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
                          child: SizedBox(
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
                              color: AppColors.whiteColor,
                              fontFamily: 'Montserrat',
                              fontSize: AppFontsSize.fontSize50,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Power of World'.toUpperCase(),
                            style: TextStyle(
                              color: AppColors.primaryColor,
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
                                color: AppColors.whiteColor,
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
                            color: AppColors.greyColor,
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
                            color: AppColors.whiteColor,
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
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w100,
                          ),
                          prefix: IconBroken.Lock,
                        ),
                        const SizedBox(height: 50),
                        DefaultButton(
                          backgroundColor:AppColors.primaryColor.withOpacity(0.5),
                          borderColor: Colors.transparent,
                          buttonWidget: Text(
                            'Reset',
                            style: TextStyle(
                              color: AppColors.whiteColor,
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
      ),
    );
  }
}
