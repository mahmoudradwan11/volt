/// The logged-in customer's profile, as returned by
/// POST /user/profile (body: token).
class ProfileModel {
  String? name;
  String? email;
  String? phone;
  String? nationalId;
  String? gender;
  String? profileImage;

  ProfileModel({
    this.name,
    this.email,
    this.phone,
    this.nationalId,
    this.gender,
    this.profileImage,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;
    name = user['name'];
    email = user['email'];
    phone = user['phone'];
    nationalId = user['nationalId'];
    gender = user['gender'];
    profileImage = user['profileImage'];
  }
}
