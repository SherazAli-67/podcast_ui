import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast_ui/constants/number_constant.dart';
import 'package:podcast_ui/constants/string_const.dart';
import 'package:podcast_ui/core/app_colors.dart';
import 'package:podcast_ui/core/app_textstyles.dart';
import 'package:podcast_ui/core/asset_res.dart';
import 'package:podcast_ui/routing/router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          _buildHeaderRings(),
          SafeArea(
            child: Padding(
              padding: .fromLTRB(
                NumberConstant.horizontalPadding,
                NumberConstant.screenTopPadding,
                NumberConstant.horizontalPadding,
                0,
              ),
              child: Column(
                crossAxisAlignment: .start,
                spacing: NumberConstant.sectionSpacing,
                children: [
                  _buildHeadline(),
                  _buildSubtitle(),
                  _buildGetStartedButton(context),
                ],
              ),
            ),
          ),
          _buildPreview()
        ],
      ),
    );
  }

  Widget _buildHeaderRings() {
    return const Align(
      alignment: .topLeft,
      child: Image(image: AssetImage(AssetRes.welcomePageHeaderRings), fit: .contain,),
    );
  }

  Widget _buildHeadline() {
    return const Column(
      crossAxisAlignment: .start,
      spacing: NumberConstant.itemSpacing,
      children: [
        Text(StringConst.welcomeHeadlineLine1, style: AppTextStyles.welcomeHeadline,),
        Text(StringConst.welcomeHeadlineLine2, style: AppTextStyles.welcomeHeadline,),
      ],
    );
  }

  Widget _buildSubtitle() {
    return const Text(StringConst.welcomeSubtitle, style: AppTextStyles.welcomeSubtitle,);
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Align(
      alignment: .centerLeft,
      child: Material(
        color: AppColors.whiteColor,
        borderRadius: .circular(NumberConstant.buttonRadius),
        child: InkWell(
          onTap: () => context.go(NamedRoutes.home.routeName),
          borderRadius: .circular(NumberConstant.buttonRadius),
          child: const Padding(
            padding: .symmetric(horizontal: 28, vertical: 14),
            child: Text(StringConst.getStarted, style: AppTextStyles.buttonLabel,),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return const Align(
      alignment: .bottomCenter,
      child: Image(image: AssetImage(AssetRes.welcomePageImg), fit: .contain,),
    );
  }
}
