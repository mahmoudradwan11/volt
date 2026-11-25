class AppValuesConstant {
  static const int timer = 3;
}

class AppFontsSize {
  static const double fontSize9 = 9;
  static const double fontSize10 = 10;
  static const double fontSize12 = 12;
  static const double fontSize14 = 14;
  static const double fontSize15 = 15;
  static const double fontSize18 = 18;
  static const double fontSize20 = 20;
  static const double fontSize25 = 25;
  static const double fontSize30 = 30;
  static const double fontSize40 = 40;
  static const double fontSize50 = 50;
}

class AppValuesForWAndH {
  static const double width6 = 60;
  static const double height1 = 10;
  static const double height2 = 20;
  static const double height3 = 30;
  static const double height4 = 40;

}

String? nextScreen;
bool? board;
var nationalId;
var token;
var adminId = '12345678910123';

/// Role split at login: a nationalId ending with this suffix is the admin
/// account and opens the admin UI; any other account opens the user app.
/// Change it here if the admin account ever changes.
const String adminNationalIdSuffix = '70';

bool isAdminNationalId(Object? id) =>
    id != null && id.toString().endsWith(adminNationalIdSuffix);

/*
var companyImage;
var bestSellerImage;

 */
