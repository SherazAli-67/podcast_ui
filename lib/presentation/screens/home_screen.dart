import 'package:flutter/material.dart';
import 'package:podcast_ui/constants/number_constant.dart';
import 'package:podcast_ui/constants/string_const.dart';
import 'package:podcast_ui/core/app_colors.dart';
import 'package:podcast_ui/core/app_textstyles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: .fromLTRB(
            NumberConstant.horizontalPadding,
            NumberConstant.screenTopPadding,
            NumberConstant.horizontalPadding,
            0,
          ),
          child: const Text(StringConst.homeTitle, style: AppTextStyles.screenTitle,),
        ),
      ),
    );
  }
}
