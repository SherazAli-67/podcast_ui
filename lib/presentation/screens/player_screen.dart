import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class _PlayerScreenState extends State<PlayerScreen> {
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    final show = AppData.showById(widget.showId ?? AppData.nowPlaying.id);
    return Scaffold(
      backgroundColor: AppColors.gradientBottomColor,
      body: Stack(
        alignment: .center,
        fit: .expand,
        children: [
          Image.asset(AssetRes.playerScreenBgImg, fit: .cover,),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              spacing: 40,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: .circle,
                        color: AppColors.pinkBgColor.withValues(alpha: 0.4)
                      ),
                      padding: .all(10),
                      child: Icon(Icons.arrow_back_ios_new, size: 20,),
                    ),
                    Text(show.title, style: AppTextStyles.playerShowTitle, textAlign: .center,),
                    Container(
                      decoration: BoxDecoration(
                          shape: .circle,
                          color: AppColors.pinkBgColor.withValues(alpha: 0.4)
                      ),
                      padding: .all(10),
                      child: Icon(Icons.more_horiz)
                    ),
                  ],
                ),
                Text(show.episodeTitle, style: AppTextStyles.episodeTitle, textAlign: .center,)
              ],
            ),
          ),

          Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    spacing: 15,
                    children: [
                      Expanded(child: SvgPicture.asset(AssetRes.icLeftSideWaves)),
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
                      Expanded(child: SvgPicture.asset(AssetRes.icRightSideWaves)),

                    ],
                  ),
                  Align(
                    alignment: .center,
                    child: Text('${show.currentTime}${StringConst.timeSeparator}${show.duration}', style: AppTextStyles.timeLabel,),
                  ),
                  Row(
                    mainAxisSize: .min,
                    mainAxisAlignment: .center,
                    spacing: 16,
                    children: [
                      SvgPicture.asset(AssetRes.icShuffle),
                      Container(
                        decoration: BoxDecoration(
                          border: .all(color: Colors.white.withValues(alpha: 0.4)),
                          shape: .circle
                        ),
                        padding: .all(12),
                        child: SvgPicture.asset(AssetRes.icPrevious),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: .all(color: Colors.white.withValues(alpha: 0.4)),
                            shape: .circle
                        ),
                        padding: .all(12),
                        child: SvgPicture.asset(AssetRes.icNext),
                      ),
                      SvgPicture.asset(AssetRes.icRepeat),

                    ],
                  ),
                ],
              )),
          Positioned(
              left: 50,
              right: 50,
              bottom: 0,
              child: Text(StringConst.playerScreenSubtitles, textAlign: .center, style: AppTextStyles.playerShowTitle.copyWith(color: Colors.white.withValues(alpha: 0.5,), height: 2, fontFamily: StringConst.heloTypeFontFamily),))
        ],
      )
    );
  }
}

