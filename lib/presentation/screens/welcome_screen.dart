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
                  LinearProgressIndicator(value: 0.6, minHeight: 1, color: Colors.white, backgroundColor: Colors.white.withValues(alpha: 0.3),),
                  RichText(text: TextSpan(
                    text: 'Enjoy Your ', style: TextStyle(fontSize: 40, fontFamily: StringConst.appFontFamilyPoppins, fontWeight: .w400),
                    children: [
                      TextSpan(
                        text: "Podcast, ", style: AppTextStyles.welcomeHeadline
                      ),
                      TextSpan(
                        text: 'Enjoy Your ', style: TextStyle(fontSize: 40, fontFamily: StringConst.appFontFamilyPoppins, fontWeight: .w400),
                      ),
                      TextSpan(
                          text: "Life", style: AppTextStyles.welcomeHeadline
                      ),
                    ]
                  )),
                  Text(StringConst.welcomeSubtitle, style: AppTextStyles.welcomeSubtitle,),
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

  Widget _buildGetStartedButton(BuildContext context) {
    return Align(
      alignment: .centerLeft,
      child: Material(
        color: AppColors.pinkBgColor,
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
