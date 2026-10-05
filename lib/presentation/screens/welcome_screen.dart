import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast_ui/constants/number_constant.dart';
import 'package:podcast_ui/constants/string_const.dart';
import 'package:podcast_ui/core/app_colors.dart';
import 'package:podcast_ui/core/app_textstyles.dart';
import 'package:podcast_ui/core/asset_res.dart';
import 'package:podcast_ui/routing/router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: NumberConstant.welcomeEntranceDurationMs),
  )..forward();

  late final Animation<double> _ringsFade = _curved(.0, .35);
  late final Animation<double> _ringsScale = Tween(begin: NumberConstant.welcomeRingsStartScale, end: 1.0).animate(_curved(.0, .35));
  late final Animation<double> _progress = Tween(begin: 0.0, end: NumberConstant.welcomeProgressValue).animate(_curved(.1, .4));
  late final Animation<double> _headlineFade = _curved(.2, .5);
  late final Animation<Offset> _headlineSlide = Tween(begin: Offset(0, NumberConstant.welcomeSlideOffset), end: Offset.zero).animate(_curved(.2, .5));
  late final Animation<double> _subtitleFade = _curved(.3, .55);
  late final Animation<Offset> _subtitleSlide = Tween(begin: Offset(0, NumberConstant.welcomeSlideOffset), end: Offset.zero).animate(_curved(.3, .55));
  late final Animation<double> _buttonFade = _curved(.4, .65);
  late final Animation<Offset> _buttonSlide = Tween(begin: Offset(0, NumberConstant.welcomeSlideOffset), end: Offset.zero).animate(_curved(.4, .65));
  late final Animation<double> _previewFade = _curved(.45, .9);
  late final Animation<Offset> _previewSlide = Tween(begin: Offset(0, NumberConstant.welcomePreviewSlideOffset), end: Offset.zero).animate(_curved(.45, .9));

  bool _isButtonPressed = false;

  CurvedAnimation _curved(double begin, double end) {
    return CurvedAnimation(parent: _controller, curve: Interval(begin, end, curve: Curves.easeOutCubic),);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
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
                    LinearProgressIndicator(value: _progress.value, minHeight: 1, color: Colors.white, backgroundColor: Colors.white.withValues(alpha: 0.3),),
                    Transform.translate(
                      offset: _headlineSlide.value,
                      child: Opacity(
                        opacity: _headlineFade.value,
                        child: RichText(text: TextSpan(
                          text: 'Enjoy Your ', style: TextStyle(fontSize: 40, fontFamily: StringConst.appFontFamilyPoppins, fontWeight: .w400),
                          children: [
                            TextSpan(text: "Podcast, ", style: AppTextStyles.welcomeHeadline),
                            TextSpan(text: 'Enjoy Your ', style: TextStyle(fontSize: 40, fontFamily: StringConst.appFontFamilyPoppins, fontWeight: .w400),),
                            TextSpan(text: "Life", style: AppTextStyles.welcomeHeadline),
                          ],
                        )),
                      ),
                    ),
                    Transform.translate(
                      offset: _subtitleSlide.value,
                      child: Opacity(opacity: _subtitleFade.value, child: Text(StringConst.welcomeSubtitle, style: AppTextStyles.welcomeSubtitle,),),
                    ),
                    Transform.translate(offset: _buttonSlide.value, child: Opacity(opacity: _buttonFade.value, child: _buildGetStartedButton(context),),),
                  ],
                ),
              ),
            ),
            _buildPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRings() {
    return Align(
      alignment: .topLeft,
      child: Opacity(
        opacity: _ringsFade.value,
        child: Transform.scale(
          scale: _ringsScale.value,
          alignment: .topLeft,
          child: const Image(image: AssetImage(AssetRes.welcomePageHeaderRings), fit: .contain,),
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Align(
      alignment: .centerLeft,
      child: AnimatedScale(
        scale: _isButtonPressed ? NumberConstant.welcomeButtonPressScale : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: AppColors.pinkBgColor,
          borderRadius: .circular(NumberConstant.buttonRadius),
          child: InkWell(
            onTap: () => context.go(NamedRoutes.home.routeName),
            onTapDown: (_) => setState(() => _isButtonPressed = true),
            onTapUp: (_) => setState(() => _isButtonPressed = false),
            onTapCancel: () => setState(() => _isButtonPressed = false),
            borderRadius: .circular(NumberConstant.buttonRadius),
            child: const Padding(
              padding: .symmetric(horizontal: 28, vertical: 14),
              child: Text(StringConst.getStarted, style: AppTextStyles.buttonLabel,),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Align(
      alignment: .bottomCenter,
      child: Transform.translate(
        offset: _previewSlide.value,
        child: Opacity(
          opacity: _previewFade.value,
          child: const Image(image: AssetImage(AssetRes.welcomePageImg), fit: .contain,),
        ),
      ),
    );
  }
}
