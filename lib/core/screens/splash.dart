import 'dart:async';
import 'package:flutter/material.dart';
import 'package:volt/core/barrel_core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  _startTimer() {
    _timer = Timer(const Duration(seconds: AppValuesConstant.timer), _goNext);
  }

  _goNext() {
    Navigator.pushNamed(context, nextScreen!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defaultColor,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image(image: AssetImage(AppImages.splash)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}
