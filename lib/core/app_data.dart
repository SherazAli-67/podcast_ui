import 'package:podcast_ui/constants/string_const.dart';
import 'package:podcast_ui/core/asset_res.dart';
import 'package:podcast_ui/core/models/podcast_show.dart';

class AppData {
  static const categories = [
    StringConst.categoryRelation,
    StringConst.categoryFamily,
    StringConst.categoryFriends,
    StringConst.categoryFeelings,
  ];

  static const defaultCategory = StringConst.categoryFamily;

  static const featuredShow = PodcastShow(
    id: 'featured_nick_john',
    title: 'Nick & John',
    host: 'Nick & John',
    episodeTitle: 'Solving your family matters & relation',
    coverImage: AssetRes.imgFeaturedNickJohn,
    category: StringConst.categoryFamily,
    duration: '02:34',
    currentTime: '00:23',
    subtitle: 'Solving your family matters & relation',
  );

  static const nowPlaying = PodcastShow(
    id: 'angry_coach',
    title: 'The Angry Coach',
    host: 'The Angry Coach',
    episodeTitle: 'Turning Connection into Opportunities',
    coverImage: AssetRes.imgAngryCoach,
    category: StringConst.categoryRelation,
    duration: '02:34',
    currentTime: '00:23',
  );

  static const shows = [
    PodcastShow(
      id: 'give_it_a_shot',
      title: 'Give it A Shot',
      host: 'Robert James',
      episodeTitle: 'Give it A Shot',
      coverImage: AssetRes.imgGiveItAShot,
      category: StringConst.categoryFamily,
      duration: '03:12',
      currentTime: '00:00',
    ),
    PodcastShow(
      id: 'amazing_life',
      title: 'Amazing Life',
      host: 'Dr. Erik',
      episodeTitle: 'Amazing Life',
      coverImage: AssetRes.imgAmazingLife,
      category: StringConst.categoryFriends,
      duration: '04:05',
      currentTime: '00:00',
    ),
    PodcastShow(
      id: 'family_matters',
      title: 'Family Matters',
      host: 'Sarah Lane',
      episodeTitle: 'Talking Through Conflict',
      coverImage: AssetRes.imgFamilyMatters,
      category: StringConst.categoryFamily,
      duration: '05:20',
      currentTime: '00:00',
    ),
    PodcastShow(
      id: 'open_feelings',
      title: 'Open Feelings',
      host: 'Mia Brooks',
      episodeTitle: 'Naming What You Feel',
      coverImage: AssetRes.imgFeelings,
      category: StringConst.categoryFeelings,
      duration: '02:48',
      currentTime: '00:00',
    ),
    PodcastShow(
      id: 'angry_coach',
      title: 'The Angry Coach',
      host: 'The Angry Coach',
      episodeTitle: 'Turning Connection into Opportunities',
      coverImage: AssetRes.imgAngryCoach,
      category: StringConst.categoryRelation,
      duration: '02:34',
      currentTime: '00:23',
    ),
    PodcastShow(
      id: 'nick_john_show',
      title: 'Nick & John',
      host: 'Nick & John',
      episodeTitle: 'Solving your family matters & relation',
      coverImage: AssetRes.imgFeaturedNickJohn,
      category: StringConst.categoryRelation,
      duration: '02:34',
      currentTime: '00:00',
      subtitle: 'Solving your family matters & relation',
    ),
  ];

  static List<PodcastShow> showsForCategory(String category) {
    return shows.where((show) => show.category == category).toList();
  }
}
