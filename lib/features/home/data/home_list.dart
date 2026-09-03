import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:volt/features/products/screens/Product.dart';
import 'package:volt/users/Screens/cateogry.dart';
import 'package:volt/users/Screens/orders.dart';
import 'package:volt/users/Screens/profile.dart';
import 'package:volt/users/Screens/wishlist.dart';
import 'package:volt/features/products/models/user_home_cate_model.dart';

List<GButton> tabs =const [
  GButton(icon:Icons.home_rounded,text: 'Home',),
  GButton(icon:Icons.grid_view_rounded,text: 'Category',),
  GButton(icon:Icons.receipt_long_rounded,text:'Orders',),
  GButton(icon:Icons.favorite_border_rounded,text: 'Wishlist',),
  GButton(icon:Icons.person_outline_rounded,text: 'Profile',),
];

List<Widget> screens = [
  ProductScreen(),
  CategoryScreen(),
  OrdersScreens(),
  WishlistScreen(),
  ProfileScreen()
];
List<UserHomeCateModel> userHomeCateModel = [
  UserHomeCateModel('Laptops',0, 'assests/images/laptop_cate.png'),
  UserHomeCateModel('Smart phone', 1 ,'assests/images/phone_cate.png'),
  UserHomeCateModel('Smart watch', 2,'assests/images/smart_watch_cate.png'),
  UserHomeCateModel('Smart Tvs',3,'assests/images/tvs_cate.png'),
  UserHomeCateModel('Accessories',4,'assests/images/acc_cate.png'),
];
