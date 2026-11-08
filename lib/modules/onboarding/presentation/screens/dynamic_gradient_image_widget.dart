import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class DynamicGradientImageWidget extends StatefulWidget {
  final String imageUrl; // أو AssetImage / FileImage

  const DynamicGradientImageWidget({super.key, required this.imageUrl});

  @override
  State<DynamicGradientImageWidget> createState() => _DynamicGradientImageWidgetState();
}

class _DynamicGradientImageWidgetState extends State<DynamicGradientImageWidget> {
  Color _dominantColor = Colors.black; // لون افتراضي
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _updatePalette();
  }

  // دالة استخراج الألوان من الصورة
  Future<void> _updatePalette() async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.imageUrl),
    );

    setState(() {
      // نأخذ اللون المهيمن أو اللون الداكن من الصورة
      _dominantColor = paletteGenerator.darkMutedColor?.color ??
          paletteGenerator.dominantColor?.color ??
          Colors.black;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. الصورة الأصلية
        Image.asset(
          widget.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        // 2. التدرج المبني على لون الصورة المستخرج
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  _dominantColor.withValues(alpha: 0.5),
                  _dominantColor.withValues(alpha: 0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}