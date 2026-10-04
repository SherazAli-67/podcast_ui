import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:podcast_ui/constants/string_const.dart';
import 'package:podcast_ui/core/app_colors.dart';
import 'package:podcast_ui/routing/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: StringConst.appTitle,
      theme: ThemeData(
        brightness: .dark,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        fontFamily: 'Poppins',
      ),
      builder: (ctx, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: child!,
        );
      },
      routerConfig: router,
    );
  }
}
