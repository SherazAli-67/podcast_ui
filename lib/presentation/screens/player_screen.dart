import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast_ui/constants/number_constant.dart';
import 'package:podcast_ui/constants/string_const.dart';
import 'package:podcast_ui/core/app_colors.dart';
import 'package:podcast_ui/core/app_data.dart';
import 'package:podcast_ui/core/app_textstyles.dart';
import 'package:podcast_ui/core/asset_res.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, this.showId});

  final String? showId;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with TickerProviderStateMixin {
  bool _isPlaying = true;
  bool _isPlayPressed = false;

  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: NumberConstant.playerEntranceDurationMs),
  );

  late final AnimationController _spinController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: NumberConstant.playerPlaybackLoopMs),
  );

  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: NumberConstant.playerPulseLoopMs),
  );

  late final Animation<double> _bgFade = _curved(.0, .45);
  late final Animation<double> _bgScale = Tween(begin: NumberConstant.playerBgStartScale, end: 1.0).animate(_curved(.0, .55));
  late final Animation<double> _headerFade = _curved(.1, .4);
  late final Animation<Offset> _headerSlide = Tween(begin: Offset(0, -NumberConstant.playerSlideOffset), end: Offset.zero).animate(_curved(.1, .4));
  late final Animation<double> _episodeFade = _curved(.22, .5);
  late final Animation<Offset> _episodeSlide = Tween(begin: Offset(0, NumberConstant.playerSlideOffset), end: Offset.zero).animate(_curved(.22, .5));
  late final Animation<double> _controlsFade = _curved(.35, .7);
  late final Animation<Offset> _controlsSlide = Tween(begin: Offset(0, NumberConstant.playerControlsSlideOffset), end: Offset.zero).animate(_curved(.35, .7));
  late final Animation<double> _playScale = Tween(begin: NumberConstant.playerPlayStartScale, end: 1.0).animate(_curved(.4, .75));
  late final Animation<double> _playFade = _curved(.4, .7);
  late final Animation<double> _transportFade = _curved(.55, .85);
  late final Animation<Offset> _transportSlide = Tween(begin: Offset(0, NumberConstant.playerSlideOffset), end: Offset.zero).animate(_curved(.55, .85));
  late final Animation<double> _subtitleFade = _curved(.7, 1.0);
  late final Animation<Offset> _subtitleSlide = Tween(begin: Offset(0, NumberConstant.playerSlideOffset), end: Offset.zero).animate(_curved(.7, 1.0));

  late final Animation<double> _ringPulse = Tween(begin: 1.0, end: NumberConstant.playerRingPulseScale).animate(
    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
  );
  late final Animation<double> _waveOpacity = Tween(begin: NumberConstant.playerWaveMinOpacity, end: 1.0).animate(
    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
  );
  late final Animation<double> _waveScaleX = Tween(begin: 0.96, end: 1.04).animate(
    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
  );

  CurvedAnimation _curved(double begin, double end) {
    return CurvedAnimation(parent: _entranceController, curve: Interval(begin, end, curve: Curves.easeOutCubic),);
  }

  @override
  void initState() {
    super.initState();
    _entranceController.forward();
    _startPlaybackMotion();
  }

  void _startPlaybackMotion() {
    _spinController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _stopPlaybackMotion() {
    _spinController.stop();
    _pulseController.stop();
  }

  void _togglePlay() {
    HapticFeedback.lightImpact();
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _startPlaybackMotion();
    } else {
      _stopPlaybackMotion();
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final show = AppData.showById(widget.showId ?? AppData.nowPlaying.id);
    return Scaffold(
      backgroundColor: AppColors.gradientBottomColor,
      body: AnimatedBuilder(
        animation: Listenable.merge([_entranceController, _spinController, _pulseController]),
        builder: (context, child) => Stack(
          alignment: .center,
          fit: .expand,
          children: [
            Opacity(
              opacity: _bgFade.value,
              child: Transform.scale(
                scale: _bgScale.value,
                child: Image.asset(AssetRes.playerScreenBgImg, fit: .cover,),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Transform.translate(
                offset: _headerSlide.value,
                child: Opacity(
                  opacity: _headerFade.value,
                  child: Column(
                    spacing: 40,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          _buildHeaderButton(
                            icon: Icons.arrow_back_ios_new,
                            onTap: () => context.pop(),
                          ),
                          Expanded(child: Text(show.title, style: AppTextStyles.playerShowTitle, textAlign: .center,),),
                          _buildHeaderButton(icon: Icons.more_horiz, onTap: () {},),
                        ],
                      ),
                      Transform.translate(
                        offset: _episodeSlide.value,
                        child: Opacity(
                          opacity: _episodeFade.value,
                          child: Text(show.episodeTitle, style: AppTextStyles.episodeTitle, textAlign: .center,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Transform.translate(
                offset: _controlsSlide.value,
                child: Opacity(
                  opacity: _controlsFade.value,
                  child: Column(
                    spacing: 16,
                    children: [
                      Row(
                        spacing: 15,
                        children: [
                          Expanded(child: _buildWave(AssetRes.icLeftSideWaves, flip: false),),
                          Opacity(
                            opacity: _playFade.value,
                            child: Transform.scale(
                              scale: _playScale.value * (_isPlayPressed ? NumberConstant.playerPlayPressScale : 1) * (_isPlaying ? _ringPulse.value : 1),
                              child: _buildPlayButton(),
                            ),
                          ),
                          Expanded(child: _buildWave(AssetRes.icRightSideWaves, flip: true),),
                        ],
                      ),
                      Align(
                        alignment: .center,
                        child: Text('${show.currentTime}${StringConst.timeSeparator}${show.duration}', style: AppTextStyles.timeLabel,),
                      ),
                      Transform.translate(
                        offset: _transportSlide.value,
                        child: Opacity(
                          opacity: _transportFade.value,
                          child: _buildTransportControls(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 50,
              right: 50,
              bottom: 0,
              child: Transform.translate(
                offset: _subtitleSlide.value,
                child: Opacity(
                  opacity: _subtitleFade.value,
                  child: Text(
                    StringConst.playerScreenSubtitles,
                    textAlign: .center,
                    style: AppTextStyles.playerShowTitle.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      height: 2,
                      fontFamily: StringConst.heloTypeFontFamily,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: .circle,
          color: AppColors.pinkBgColor.withValues(alpha: 0.4),
        ),
        padding: .all(10),
        child: Icon(icon, size: 20,),
      ),
    );
  }

  Widget _buildWave(String asset, {required bool flip}) {
    final opacity = _isPlaying ? _waveOpacity.value : NumberConstant.playerWaveMinOpacity;
    final scaleX = _isPlaying ? _waveScaleX.value : 1.0;
    return Opacity(
      opacity: opacity,
      child: Transform(
        alignment: .center,
        transform: Matrix4.diagonal3Values(flip ? scaleX : scaleX, 1, 1),
        child: SvgPicture.asset(asset),
      ),
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: _togglePlay,
      onTapDown: (_) => setState(() => _isPlayPressed = true),
      onTapUp: (_) => setState(() => _isPlayPressed = false),
      onTapCancel: () => setState(() => _isPlayPressed = false),
      child: Stack(
        alignment: .center,
        children: [
          Transform.rotate(
            angle: _spinController.value * 2 * math.pi,
            child: SvgPicture.asset(AssetRes.icPlayPauseRing,),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: .circle,
            ),
            child: Padding(
              padding: .all(NumberConstant.playButtonPadding),
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: NumberConstant.playerAnimFastMs),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child,),
                ),
                child: SvgPicture.asset(
                  _isPlaying ? AssetRes.icPause : AssetRes.icPlay,
                  key: ValueKey(_isPlaying),
                  colorFilter: .mode(AppColors.blackColor, .srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportControls() {
    return Row(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      spacing: 16,
      children: [
        SvgPicture.asset(AssetRes.icShuffle),
        _buildTransportButton(AssetRes.icPrevious),
        _buildTransportButton(AssetRes.icNext),
        SvgPicture.asset(AssetRes.icRepeat),
      ],
    );
  }

  Widget _buildTransportButton(String icon) {
    return Container(
      decoration: BoxDecoration(
        border: .all(color: Colors.white.withValues(alpha: 0.4)),
        shape: .circle,
      ),
      padding: .all(12),
      child: SvgPicture.asset(icon),
    );
  }
}
