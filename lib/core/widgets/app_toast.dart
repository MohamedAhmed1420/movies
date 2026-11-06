import 'package:flutter/material.dart';

class AppToast {
  const AppToast._();

  static void show({
    required String title,
    required BuildContext context,
    AppToastType type = AppToastType.success,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: type.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Text(title),
      ),
    );
  }
}

enum AppToastType {
  error(Colors.red),
  success(Colors.green);

  final Color color;

  const AppToastType(this.color);
}
