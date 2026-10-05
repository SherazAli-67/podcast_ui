import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast_ui/constants/number_constant.dart';
import 'package:podcast_ui/constants/string_const.dart';
import 'package:podcast_ui/core/app_colors.dart';
import 'package:podcast_ui/core/app_data.dart';
import 'package:podcast_ui/core/app_textstyles.dart';
import 'package:podcast_ui/core/asset_res.dart';
import 'package:podcast_ui/core/models/podcast_show.dart';
import 'package:podcast_ui/routing/router.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, this.showId});

  final String? showId;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    final show = AppData.showById(widget.showId ?? AppData.nowPlaying.id);
    return Scaffold(
      backgroundColor: AppColors.gradientBottomColor,
      body: Stack(
        fit: .expand,
        children: [
          _buildBackground(),
          SafeArea(
            child: Padding(
              padding: .fromLTRB(
                NumberConstant.horizontalPadding,
                NumberConstant.screenTopPadding,
                NumberConstant.horizontalPadding,
                NumberConstant.screenTopPadding,
              ),
              child: Column(
                crossAxisAlignment: .start,
                spacing: NumberConstant.sectionSpacing,
                children: [
                  _buildHeader(show),
                  Text(show.episodeTitle, style: AppTextStyles.episodeTitle,),
                  Expanded(child: _buildArtwork(show)),
                  _buildPlayerControls(show),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return const Stack(
      fit: .expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [
                AppColors.gradientTopColor,
                AppColors.backgroundColor,
                AppColors.gradientBottomColor,
              ],
            ),
          ),
        ),
        Align(
          alignment: .topLeft,
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(<double>[
              1, 0, 0, 0, 0,
              0, 1, 0, 0, 0,
              0, 0, 1, 0, 0,
              0, 0, 0, 10, 0,
            ]),
            child: Image(
              image: AssetImage(AssetRes.welcomePageHeaderRings),
              fit: .contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(PodcastShow show) {
    return Row(
      children: [
        _buildCircleButton(
          icon: AssetRes.icArrowBack,
          onTap: () => context.canPop() ? context.pop() : context.go(NamedRoutes.home.routeName),
        ),
        Expanded(child: Text(show.title, style: AppTextStyles.playerShowTitle, textAlign: .center,)),
        _buildCircleButton(icon: AssetRes.icMore, onTap: () {}),
      ],
    );
  }

  Widget _buildCircleButton({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withValues(alpha: 0.1),
          shape: .circle,
        ),
        child: Padding(
          padding: .all(NumberConstant.playerIconPadding),
          child: SvgPicture.asset(icon,),
        ),
      ),
    );
  }

  Widget _buildArtwork(PodcastShow show) {
    return Stack(
      alignment: .center,
      children: [
        Image.asset(show.coverImage, height: NumberConstant.playerArtworkHeight, fit: .contain,),
        const Positioned(top: 12, left: 8, child: _PlayerStar()),
        const Positioned(top: 72, right: 16, child: _PlayerStar()),
        const Positioned(bottom: 36, left: 28, child: _PlayerStar()),
      ],
    );
  }

  Widget _buildPlayerControls(PodcastShow show) {
    return Column(
      spacing: NumberConstant.itemSpacing,
      children: [
        _buildWaveControl(),
        Align(
          alignment: .centerRight,
          child: Text('${show.currentTime}${StringConst.timeSeparator}${show.duration}', style: AppTextStyles.timeLabel,),
        ),
        _buildTransportRow(),
      ],
    );
  }

  Widget _buildWaveControl() {
    return SizedBox(
      height: NumberConstant.playRingHeight,
      child: Stack(
        alignment: .center,
        children: [
          Row(
            children: [
              Expanded(child: SvgPicture.asset(AssetRes.icLeftSideWaves, fit: .fitWidth,),),
              Expanded(child: SvgPicture.asset(AssetRes.icRightSideWaves, fit: .fitWidth,),),
            ],
          ),
          GestureDetector(
            onTap: () => setState(() => _isPlaying = !_isPlaying),
            child: Stack(
              alignment: .center,
              children: [
                SvgPicture.asset(AssetRes.icPlayPauseRing,),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: .circle,
                  ),
                  child: Padding(
                    padding: .all(NumberConstant.playButtonPadding),
                    child: SvgPicture.asset(
                      _isPlaying ? AssetRes.icPause : AssetRes.icPlay,
                      colorFilter: .mode(AppColors.blackColor, .srcIn),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportRow() {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        SvgPicture.asset(AssetRes.icShuffle,),
        SvgPicture.asset(AssetRes.icPrevious,),
        SvgPicture.asset(AssetRes.icNext,),
        SvgPicture.asset(AssetRes.icRepeat,),
      ],
    );
  }
}

class _PlayerStar extends StatelessWidget {
  const _PlayerStar();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AssetRes.icStar,);
  }
}
