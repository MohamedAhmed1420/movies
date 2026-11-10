import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/auth/domain/entities/app_user.dart';
import 'package:movies/modules/auth/presentation/manager/auth_cubit.dart';
import 'package:movies/modules/auth/presentation/widgets/avatar_selector.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser user;
  final VoidCallback onBack;
  final ValueChanged<AppUser> onSaved;

  const EditProfileScreen({
    super.key,
    required this.user,
    required this.onBack,
    required this.onSaved,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late String? _avatarUrl;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  String _text(String en, String ar) => _isArabic ? ar : en;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
    _avatarUrl = widget.user.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _showAvatarPicker() async {
    final selectedAvatar = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Container(
          height: MediaQuery.sizeOf(sheetContext).height * 0.48,
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Text(
                _text('Pick Avatar', 'اختر صورة شخصية'),
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: AvatarSelector.avatars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 9,
                    crossAxisSpacing: 9,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {
                    final url = AvatarSelector.avatars[index];
                    final selected = _avatarUrl == url;
                    return InkWell(
                      borderRadius: BorderRadius.circular(13),
                      onTap: () => Navigator.of(sheetContext).pop(url),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.yellow.withValues(alpha: 0.16)
                              : const Color(0xFF202120),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: selected ? AppColors.yellow : AppColors.gray,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.person,
                              color: AppColors.yellow,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selectedAvatar != null && mounted) {
      setState(() => _avatarUrl = selectedAvatar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
              ),
              Expanded(
                child: Text(
                  _text('Edit Profile', 'تعديل الملف الشخصي'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
            children: [
              Center(
                child: InkWell(
                  onTap: _showAvatarPicker,
                  customBorder: const CircleBorder(),
                  child: _ProfileAvatar(imageUrl: _avatarUrl, radius: 46),
                ),
              ),
              const SizedBox(height: 22),
              _ProfileTextField(
                controller: _nameController,
                icon: Icons.person_rounded,
                hint: l10n.name,
              ),
              const SizedBox(height: 10),
              _ProfileTextField(
                controller: _emailController,
                icon: Icons.email_rounded,
                hint: l10n.email,
                readOnly: true,
              ),
              const SizedBox(height: 14),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () {
                    final email = widget.user.email;
                    if (email != null && email.isNotEmpty) {
                      context.read<AuthCubit>().sendPasswordResetEmail(email: email);
                    }
                  },
                  child: Text(
                    _text('Reset Password', 'إعادة تعيين كلمة المرور'),
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _ActionButton(
                label: _text('Delete Account', 'حذف الحساب'),
                color: AppColors.red,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _text(
                          'Account deletion is not available yet.',
                          'حذف الحساب غير متاح حاليًا.',
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _ActionButton(
                label: _text('Update Data', 'تحديث البيانات'),
                color: AppColors.yellow,
                textColor: AppColors.black,
                onTap: () {
                  widget.onSaved(
                    AppUser(
                      id: widget.user.id,
                      email: widget.user.email,
                      displayName: _nameController.text.trim(),
                      photoUrl: _avatarUrl,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const _ProfileAvatar({required this.imageUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF164A5A),
      child: imageUrl == null || imageUrl!.isEmpty
          ? Icon(Icons.person_rounded, color: AppColors.yellow, size: radius)
          : ClipOval(
              child: Image.network(
                imageUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.person_rounded,
                  color: AppColors.yellow,
                  size: radius,
                ),
              ),
            ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.textColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          elevation: 0,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool readOnly;

  const _ProfileTextField({
    required this.controller,
    required this.icon,
    required this.hint,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(color: AppColors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.white.withValues(alpha: 0.78)),
        prefixIcon: Icon(icon, color: AppColors.white, size: 19),
        filled: true,
        fillColor: AppColors.gray,
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
