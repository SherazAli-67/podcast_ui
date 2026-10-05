import 'package:flutter/material.dart';
import 'package:podcast_ui/core/app_colors.dart';
import 'package:podcast_ui/core/app_data.dart';
import 'package:podcast_ui/core/app_textstyles.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key, this.showId});

  final String? showId;

  @override
  Widget build(BuildContext context) {
    final show = AppData.showById(showId ?? AppData.nowPlaying.id);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Text(show.episodeTitle, style: AppTextStyles.episodeTitle, textAlign: .center,),
        ),
      ),
    );
  }
}
