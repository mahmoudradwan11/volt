import 'package:flutter/material.dart';
import 'package:volt/core/mangers/colors.dart';
class DefaultFieldForm extends StatelessWidget {
  TextEditingController controller;
  TextInputType keyboard;
  var valid;
  String? label;
  String? hint;
  IconData? prefix;
  bool show;
  var tap;
  var onchange;
  var onSubmit;
  IconData? suffix;
  Function()? suffixPress;
  TextStyle? labelStyle;
  TextStyle? hintStyle;

  DefaultFieldForm({
    super.key,
    required this.controller,
    required this.keyboard,
    required this.valid,
    this.hint,
    this.label,
    this.prefix,
    this.show = false,
    this.tap,
    this.onchange,
    this.onSubmit,
    this.suffix,
    this.suffixPress,
    this.labelStyle,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style:TextStyle(color: AppColors.scaffoldBackGroundColor),
      onTapOutside: (event)=>FocusScope.of(context).unfocus(),
      validator: valid,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor:AppColors.defaultColor.withOpacity(0.5),
        hintText: hint,
        hintStyle: hintStyle,
        labelText: label,
        labelStyle: labelStyle,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.indigo.withOpacity(0.6)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color:Colors.red,)
        ),
        errorStyle:const TextStyle(color: Colors.red,fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:BorderSide(color:AppColors.defaultColor),
        ),
        // borderRadius: BorderRadius.circular(30
        prefixIcon: Icon(
          prefix,
          color:AppColors.scaffoldBackGroundColor.withOpacity(0.5)
        ),
        suffixIcon: suffix != null
            ? IconButton(
          icon: Icon(suffix),
          onPressed: suffixPress,
          color:AppColors.scaffoldBackGroundColor
        )
            : null,
      ),
      keyboardType: keyboard,
      onFieldSubmitted: onSubmit,
      onChanged:onchange,
      obscureText: show,
      onTap: tap,
    );
  }
}
