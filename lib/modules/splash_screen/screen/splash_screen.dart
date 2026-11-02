import 'package:flutter/material.dart';
import 'package:movies/core/widgets/theme/app_colors.dart';

import 'onboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      MaterialPageRoute(builder: (context) => Onboard(),);
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Image.asset("assets/logo/movies_logo.png")),
            Image.asset("assets/logo/route_logo.png",width: 200,),
            Text(
              "Supervised by Mohamed Ahmed",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
