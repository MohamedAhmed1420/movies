import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';

class LanguageSwitch extends StatefulWidget {
  final String initialLanguage;
  final ValueChanged<String>? onLanguageChanged;

  const LanguageSwitch({
    super.key,
    this.initialLanguage = 'en',
    this.onLanguageChanged,
  });

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  late bool _isArabic;

  @override
  void initState() {
    super.initState();
    _isArabic = widget.initialLanguage == 'ar';
  }

  Widget _buildFlagCircle({required String flagEmoji, required bool isSelected}) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.yellow : Colors.transparent,
      ),
      alignment: Alignment.center,
      child: Text(
        flagEmoji,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isArabic = !_isArabic;
        });
        widget.onLanguageChanged?.call(_isArabic ? 'ar' : 'en');
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.yellow, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFlagCircle(
              flagEmoji: '🇺🇸',
              isSelected: !_isArabic,
            ),
            const SizedBox(width: 4),
            _buildFlagCircle(
              flagEmoji: '🇪🇬',
              isSelected: _isArabic,
            ),
          ],
        ),
      ),
    );
  }
}
