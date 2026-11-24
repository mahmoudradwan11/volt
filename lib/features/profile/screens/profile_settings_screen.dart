import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volt/core/Widgets/text_form_feild.dart';
import 'package:volt/core/themes/app_colors.dart';
import 'package:volt/features/profile/controllers/profile_cubit.dart';
import 'package:volt/features/profile/controllers/profile_states.dart';

/// The Profile Settings form, wired to PUT /user/update. Fields prefill
/// from the profile API. The backend always re-hashes the password, so the
/// current password is required to save any change (verified live: a request
/// without password returns "Server error"). The field validates this
/// client-side - Confirm never calls the API with an empty password.
/// (The backend has no date-of-birth field, so it is omitted.)
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String gender = 'male';
  bool _showPassword = false;
  bool _saving = false;
  bool _prefilled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _prefill() {
    final profile = ProfileCubit.get(context).profile;
    if (profile == null || _prefilled) return;
    _prefilled = true;
    _nameController.text = profile.name ?? '';
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    if (profile.gender == 'female') gender = 'female';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ProfileCubit.get(context);
        _prefill();
        final image = cubit.profile?.profileImage;
        final hasImage = image != null && image.toString().isNotEmpty;
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackColor,
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldBackColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Profile Settings',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: cubit.profile == null && state is ProfileLoadingState
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 44,
                              backgroundColor: AppColors.p2Color,
                              backgroundImage: hasImage
                                  ? NetworkImage(image.toString())
                                  : null,
                              child: hasImage
                                  ? null
                                  : Icon(Icons.person,
                                      color: AppColors.subTextColor, size: 44),
                            ),
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: AppColors.p3Color,
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        DefaultFieldForm(
                          controller: _nameController,
                          keyboard: TextInputType.name,
                          valid: (value) => value == null || value.isEmpty
                              ? 'Name is required'
                              : null,
                          label: 'Name',
                          prefix: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 12),
                        DefaultFieldForm(
                          controller: _emailController,
                          keyboard: TextInputType.emailAddress,
                          valid: (value) => value == null || value.isEmpty
                              ? 'Email is required'
                              : null,
                          label: 'Email',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(height: 12),
                        DefaultFieldForm(
                          controller: _phoneController,
                          keyboard: TextInputType.phone,
                          valid: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Phone is required';
                            }
                            if (!RegExp(r'^01\d{9}$').hasMatch(value)) {
                              return 'Enter a valid Egyptian phone (01xxxxxxxxx)';
                            }
                            return null;
                          },
                          label: 'Phone',
                          prefix: Icons.phone_outlined,
                        ),
                        const SizedBox(height: 12),
                        DefaultFieldForm(
                          controller: _passwordController,
                          keyboard: TextInputType.visiblePassword,
                          valid: (value) => value == null || value.isEmpty
                              ? 'Enter your current password to save any change'
                              : null,
                          label: 'Password',
                          hint: 'Required to save any change',
                          prefix: Icons.lock_outline_rounded,
                          show: !_showPassword,
                          suffix: _showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          suffixPress: () => setState(
                              () => _showPassword = !_showPassword),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Gender',
                            style:
                                TextStyle(color: AppColors.subTextColor, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _GenderButton(
                              label: 'Male',
                              selected: gender == 'male',
                              onTap: () => setState(() => gender = 'male'),
                            ),
                            const SizedBox(width: 12),
                            _GenderButton(
                              label: 'Female',
                              selected: gender == 'female',
                              onTap: () => setState(() => gender = 'female'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.p3Color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _saving
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    setState(() => _saving = true);
                                    final ok = await cubit.updateProfile(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      gender: gender,
                                      password: _passwordController.text,
                                    );
                                    if (mounted) {
                                      setState(() => _saving = false);
                                      if (ok) Navigator.pop(context);
                                    }
                                  },
                            child: _saving
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Confirm',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.p3Color : AppColors.p2Color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.p3Color : AppColors.borderColor,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.subTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
