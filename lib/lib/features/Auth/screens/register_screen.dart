import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:volt/core/Widgets/text_form_feild.dart';
import 'package:volt/core/barrel/barrel_core.dart';
import 'package:volt/core/utils/reg_exp.dart';
import 'package:volt/core/network/local/cache_helper.dart';
import 'package:volt/features/Auth/controllers/register_cubit/register_cubit.dart';
import 'package:volt/features/Auth/controllers/register_cubit/register_states.dart';
import 'package:volt/features/home/screens/home.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var confirmController = TextEditingController();
  var nationalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is UserRegisterSuccessfully) {
            if (state.userModel.status == "success") {
              print(state.userModel.message);
              showToast(state.userModel.message!, ToastStates.SUCCESS);
              print(state.userModel.user!.token);
              CacheHelper.saveData(
                key: 'userId',
                value: state.userModel.user!.nationalId,
              ).then((value) {
                nationalId = state.userModel.user!.nationalId;
              });
              CacheHelper.saveData(
                key: 'token',
                value: state.userModel.user!.token,
              ).then((value) {
                token = state.userModel.user!.token!;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserHomeScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              });
            } else {
              print(state.userModel.message);
            }
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
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
                              'Create your account',
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
                          'Join Volt to start your journey',
                          style: TextStyle(
                            color:AppColors.greyColor,
                            fontFamily: 'Montserrat',
                            fontSize: AppFontsSize.fontSize15,
                          ),
                        ),
                        SizedBox(height: 20),
                        cubit.image == null
                            ? Center(
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primaryColor.withOpacity(0.7),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        icon: Icon(
                                          IconBroken.Camera,
                                          color: AppColors.whiteColor,
                                        ),
                                        onPressed: () {
                                          cubit.addImage();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: FileImage(cubit.image!),
                                ),
                              ),
                        SizedBox(height: AppValuesForWAndH.height2),
                        DefaultFieldForm(
                          controller: nameController,
                          keyboard: TextInputType.text,
                          valid: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Your Name';
                            }
                            return null;
                          },
                          hintStyle: TextStyle(
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w100,
                          ),
                          labelStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w100,
                          ),
                          label: 'Full Name',
                          prefix: Icons.person,
                          hint: 'Full Name',
                          show: false,
                        ),
                        const SizedBox(height: 15),
                        DefaultFieldForm(
                          controller: emailController,
                          keyboard: TextInputType.emailAddress,
                          valid: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter your Email';
                            }
                            return null;
                          },
                          hintStyle: TextStyle(
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w100,
                          ),
                          labelStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w100,
                          ),
                          label: 'Email Address',
                          prefix: Icons.email,
                          hint: 'Email Address',
                          show: false,
                        ),
                        const SizedBox(height: 15),
                        DefaultFieldForm(
                          hintStyle: TextStyle(
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w100,
                          ),
                          labelStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w100,
                          ),
                          controller: phoneController,
                          keyboard: TextInputType.phone,
                          label: 'Phone',
                          valid: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Your Phone';
                            }
                            return null;
                          },
                          prefix: Icons.phone,
                          hint: 'Phone',
                          show: false,
                        ),
                        const SizedBox(height: 15),
                        DefaultFieldForm(
                          controller: passwordController,
                          keyboard: TextInputType.visiblePassword,
                          valid: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Your Password';
                            }
                            return null;
                          },
                          hintStyle: TextStyle(
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w100,
                          ),
                          labelStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w100,
                          ),
                          label: 'Password',
                          prefix: Icons.password,
                          hint: 'Password',
                          show: cubit.isPassword,
                          suffix: cubit.suffix,
                          suffixPress: () {
                            cubit.changePasswordVisibility();
                          },
                        ),
                        const SizedBox(height: 15),
                        DefaultFieldForm(
                          controller: confirmController,
                          keyboard: TextInputType.text,
                          valid: (value) {
                            if (value.isEmpty) {
                              return 'Please Confirm Your Password';
                            }
                            return null;
                          },
                          label: 'Confirm Password',
                          prefix: Icons.confirmation_num,
                          hint: 'Confirm Password',
                          show: cubit.isPassword,
                          hintStyle: TextStyle(
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w100,
                          ),
                          labelStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w100,
                          ),
                          suffix: cubit.suffix,
                          suffixPress: () {
                            cubit.changePasswordVisibility();
                          },
                        ),
                        const SizedBox(height: 15),
                        DefaultFieldForm(
                          hintStyle: TextStyle(
                            color:AppColors.greyColor,
                            fontWeight: FontWeight.w100,
                          ),
                          labelStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w100,
                          ),
                          controller: nationalController,
                          keyboard: TextInputType.number,
                          label: 'National ID',
                          valid: (value) {
                            if (value.isEmpty) {
                              return 'Please Confirm Your National Id';
                            }
                            return null;
                          },
                          prefix: Icons.video_stable,
                          hint: 'National ID',
                          show: false,
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor: AppColors.primaryColor,
                                value: cubit.check,
                                onChanged: (value) {
                                  cubit.changeCheck(value);
                                },
                                hoverColor: Colors.yellow,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(height: 12),
                                    Text(
                                      'I Have read and agree to the privacy policy, terms of serice, and community guidelines.',
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        state is LoadingUserRegister
                            ? Center(
                              child: LoadingAnimationWidget.inkDrop(
                                  color: AppColors.whiteColor,
                                  size: 20,
                                ),
                            )
                            : DefaultButton(
                                backgroundColor:AppColors.primaryColor.withOpacity(0.5),
                                borderColor: Colors.transparent,
                                buttonWidget: const Text(
                                  'Create Account',
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    if (cubit.check == true) {
                                      if (passwordController.text ==
                                          confirmController.text) {
                                        if (Exp.isEmailValid(
                                          emailController.text,
                                        )) {
                                          if (Exp.isPhoneValid(
                                            phoneController.text,
                                          )) {
                                            cubit.userRegister(
                                              email: emailController.text,
                                              name: nameController.text,
                                              phone: phoneController.text,
                                              password: passwordController.text,
                                              nationalID: nationalController.text,
                                            );
                                          } else {
                                            showToast(
                                              'Please Enter Valid Phone Number',
                                              ToastStates.WARNING,
                                            );
                                          }
                                        } else {
                                          showToast(
                                            'Please Enter Valid Email',
                                            ToastStates.WARNING,
                                          );
                                        }
                                      } else {
                                        showToast(
                                          'Please Confirm Your Password',
                                          ToastStates.WARNING,
                                        );
                                      }
                                    } else {
                                      showToast(
                                        'Please Confirm Policy',
                                        ToastStates.WARNING,
                                      );
                                    }
                                  }
                                },
                              ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Row(
                            children: [
                              Text(
                                'Already have an account?',
                                style: TextStyle(color: AppColors.greyColor),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.login);
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
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
        },
      ),
    );
  }
}
