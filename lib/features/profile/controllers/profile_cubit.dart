import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/barrel/barrel_network.dart';
import 'package:volt/core/constants/app_values.dart';
import 'package:volt/core/constants/toast.dart';
import 'package:volt/features/profile/controllers/profile_states.dart';
import 'package:volt/features/profile/models/profile_model.dart';

/// The logged-in customer's profile (from POST /user/profile) plus the
/// notification preferences, which have no backend and are kept locally
/// in shared preferences.
class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  ProfileModel? profile;

  /// Notification preferences, persisted locally. Keyed by stable ids
  /// so the UI copy can change without losing settings.
  final Map<String, bool> notificationPrefs = {
    'account': true,
    'shipments': true,
    'recommendations': false,
    'deals': true,
    'community': false,
  };

  void loadNotificationPrefs() {
    for (final key in notificationPrefs.keys.toList()) {
      final saved = CacheHelper.getData(key: 'notif_$key');
      if (saved is bool) notificationPrefs[key] = saved;
    }
  }

  void toggleNotification(String key, bool value) {
    notificationPrefs[key] = value;
    CacheHelper.saveData(key: 'notif_$key', value: value);
    emit(ProfileSuccessState());
  }

  Future<void> getProfile() async {
    emit(ProfileLoadingState());
    try {
      final String? savedToken = CacheHelper.getData(key: 'token') ?? token;
      final value = await DioHelperStore.postData(
        url: ApiConstants.profileApi,
        data: {'token': savedToken},
      );
      profile = ProfileModel.fromJson(value.data);
      loadNotificationPrefs();
      emit(ProfileSuccessState());
    } catch (error) {
      print(error.toString());
      emit(ProfileErrorState());
    }
  }

  /// PUT /user/update. The backend always re-hashes the password, so the
  /// current password must be sent - this guard refuses to call the API
  /// without it (the form also validates this and shows the hint inline).
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String gender,
    required String password,
  }) async {
    if (password.isEmpty) {
      showToast(
        'Enter your current password to save any change',
        ToastStates.ERROR,
      );
      return false;
    }
    try {
      final String? savedToken = CacheHelper.getData(key: 'token') ?? token;
      final data = <String, dynamic>{'token': savedToken};
      if (name.trim().isNotEmpty) data['name'] = name.trim();
      if (email.trim().isNotEmpty) data['email'] = email.trim();
      if (phone.trim().isNotEmpty) data['phone'] = phone.trim();
      if (gender.isNotEmpty) data['gender'] = gender;
      if (password.isNotEmpty) data['password'] = password;

      final value = await DioHelperStore.putData(
        url: ApiConstants.editProfile,
        data: data,
      );
      if (value.data['status'] == 'success') {
        showToast('Profile updated', ToastStates.SUCCESS);
        await getProfile();
        return true;
      }
      showToast(
        value.data['message']?.toString() ?? 'Could not update profile',
        ToastStates.ERROR,
      );
      return false;
    } catch (error) {
      print(error.toString());
      showToast('Could not update profile', ToastStates.ERROR);
      return false;
    }
  }
}
