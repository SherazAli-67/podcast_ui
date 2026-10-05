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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _selectedCategory = AppData.defaultCategory;
  String? _pressedShowId;
  late final PageController _featuredController = PageController(viewportFraction: NumberConstant.featuredCarouselViewportFraction,);
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: NumberConstant.homeEntranceDurationMs),
  )..forward();

  late final Animation<double> _headerFade = _curved(.0, .3);
  late final Animation<Offset> _headerSlide = Tween(begin: Offset(0, NumberConstant.homeSlideOffset), end: Offset.zero).animate(_curved(.0, .3));
  late final Animation<double> _titleFade = _curved(.1, .4);
  late final Animation<Offset> _titleSlide = Tween(begin: Offset(0, NumberConstant.homeSlideOffset), end: Offset.zero).animate(_curved(.1, .4));
  late final Animation<double> _carouselFade = _curved(.2, .5);
  late final Animation<Offset> _carouselSlide = Tween(begin: Offset(0, NumberConstant.homeSlideOffset), end: Offset.zero).animate(_curved(.2, .5));
  late final Animation<double> _chipsFade = _curved(.35, .6);
  late final Animation<Offset> _chipsSlide = Tween(begin: Offset(0, NumberConstant.homeSlideOffset), end: Offset.zero).animate(_curved(.35, .6));
  late final Animation<double> _gridFade = _curved(.45, .75);
  late final Animation<Offset> _gridSlide = Tween(begin: Offset(0, NumberConstant.homeSlideOffset), end: Offset.zero).animate(_curved(.45, .75));
  late final Animation<double> _miniPlayerFade = _curved(.55, .9);
  late final Animation<Offset> _miniPlayerSlide = Tween(begin: Offset(0, NumberConstant.homeMiniPlayerSlideOffset), end: Offset.zero).animate(_curved(.55, .9));

  CurvedAnimation _curved(double begin, double end) {
    return CurvedAnimation(parent: _entranceController, curve: Interval(begin, end, curve: Curves.easeOutCubic),);
  }

  @override
  void dispose() {
    _featuredController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shows = AppData.showsForCategory(_selectedCategory);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AnimatedBuilder(
        animation: _entranceController,
        builder: (context, child) => Stack(
          fit: .expand,
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: .symmetric(horizontal: NumberConstant.horizontalPadding, vertical: NumberConstant.screenTopPadding),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: NumberConstant.sectionSpacing,
                  children: [
                    Transform.translate(offset: _headerSlide.value, child: Opacity(opacity: _headerFade.value, child: _buildHeader(),),),
                    Transform.translate(offset: _titleSlide.value, child: Opacity(opacity: _titleFade.value, child: _buildSectionTitle(),),),
                    Transform.translate(offset: _carouselSlide.value, child: Opacity(opacity: _carouselFade.value, child: _buildFeaturedCarousel(),),),
                    Transform.translate(offset: _chipsSlide.value, child: Opacity(opacity: _chipsFade.value, child: _buildCategoryChips(),),),
                    Transform.translate(
                      offset: _gridSlide.value,
                      child: Opacity(
                        opacity: _gridFade.value,
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: NumberConstant.homeAnimMediumMs),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: KeyedSubtree(key: ValueKey(_selectedCategory), child: _buildShowsGrid(shows),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              right: 10,
              left: 10,
              child: Transform.translate(
                offset: _miniPlayerSlide.value,
                child: Opacity(opacity: _miniPlayerFade.value, child: _buildMiniPlayer(),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.currentPlayerBgColor,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 27,
            spreadRadius: 0,
            color: Colors.black.withValues(alpha: 0.25),
          ),
        ],
      ),
      padding: .all(10),
      child: Row(
        spacing: 10,
        children: [
          ClipRRect(
            borderRadius: .circular(8),
            child: Image.asset(AssetRes.holdItOnImg),
          ),
          Expanded(child: Column(
            crossAxisAlignment: .start,
            children: [
              Text("Hold It On", style: AppTextStyles.screenTitle,),
              Text("The angry Coach Series", style: AppTextStyles.miniPlayerTitle,),
            ],
          )),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: .circle,
            ),
            padding: .all(15),
            child: SvgPicture.asset(AssetRes.icPlay),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    return SizedBox(
      height: NumberConstant.featuredCardHeight,
      child: PageView.builder(
        controller: _featuredController,
        padEnds: false,
        itemCount: AppData.featuredShows.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _featuredController,
            builder: (context, child) {
              final page = _featuredController.hasClients
                  ? (_featuredController.page ?? _featuredController.initialPage.toDouble())
                  : 0.0;
              final distance = (page - index).abs();
              final scale = (1 - (distance * (1 - NumberConstant.homeFeaturedInactiveScale))).clamp(NumberConstant.homeFeaturedInactiveScale, 1.0);
              final opacity = (1 - (distance * 0.25)).clamp(0.7, 1.0);
              return Padding(
                padding: .only(right: NumberConstant.featuredCarouselGap),
                child: Transform.scale(
                  scale: scale,
                  alignment: .centerLeft,
                  child: Opacity(opacity: opacity, child: child,),
                ),
              );
            },
            child: _buildFeaturedCard(AppData.featuredShows[index]),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildDecoratedIcon(icon: AssetRes.icDrawer),
        const Expanded(
          child: Text(
            StringConst.homeTitle,
            style: AppTextStyles.screenTitle,
            textAlign: .center,
          ),
        ),
        _buildDecoratedIcon(icon: AssetRes.icSearch),
      ],
    );
  }

  Widget _buildDecoratedIcon({required String icon}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.1),
        shape: .circle,
      ),
      child: Padding(
        padding: .symmetric(horizontal: 16.5, vertical: 23),
        child: SvgPicture.asset(icon,),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      spacing: NumberConstant.chipSpacing,
      children: [
        Text(StringConst.podcastForYou, style: AppTextStyles.sectionTitle,),
        SvgPicture.asset(AssetRes.icSearch),
      ],
    );
  }

  Widget _buildFeaturedCard(PodcastShow show) {
    final isPressed = _pressedShowId == show.id;
    return GestureDetector(
      onTap: () => _openPlayer(show),
      onTapDown: (_) => setState(() => _pressedShowId = show.id),
      onTapUp: (_) => setState(() => _pressedShowId = null),
      onTapCancel: () => setState(() => _pressedShowId = null),
      child: AnimatedScale(
        scale: isPressed ? NumberConstant.homeCardPressScale : 1,
        duration: Duration(milliseconds: NumberConstant.homeAnimFastMs),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(AssetRes.decoratedBanner), fit: .cover),
            borderRadius: .circular(NumberConstant.cardRadius),
          ),
          clipBehavior: .hardEdge,
          child: Stack(
            alignment: .center,
            children: [
              Positioned(
                left: 0,
                child: Image.asset(AssetRes.nickImg),
              ),
              Positioned(
                right: 0,
                child: Image.asset(AssetRes.johnImg),
              ),
              Positioned(
                left: 50,
                right: 50,
                child: Column(
                  mainAxisAlignment: .center,
                  spacing: 10,
                  children: [
                    Text(show.title, style: AppTextStyles.episodeTitle.copyWith(color: AppColors.goldColor, fontFamily: StringConst.heloTypeFontFamily,), textAlign: .center,),
                    Text(show.subtitle, style: AppTextStyles.showHost, textAlign: .center),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Row(
        spacing: NumberConstant.chipSpacing,
        children: [
          for (final category in AppData.categories)
            _buildCategoryChip(category),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = category == _selectedCategory;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: AnimatedContainer(
        duration: Duration(milliseconds: NumberConstant.homeAnimFastMs),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.whiteColor : AppColors.whiteColor.withValues(alpha: 0.09),
          borderRadius: .circular(NumberConstant.chipRadius),
        ),
        padding: .symmetric(
          horizontal: NumberConstant.chipHorizontalPadding,
          vertical: NumberConstant.chipVerticalPadding,
        ),
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: NumberConstant.homeAnimFastMs),
          curve: Curves.easeInOut,
          style: AppTextStyles.chipLabel.copyWith(color: isSelected ? AppColors.blackColor : AppColors.whiteColor.withValues(alpha: 0.76),),
          child: Text(category),
        ),
      ),
    );
  }

  Widget _buildShowsGrid(List<PodcastShow> shows) {
    final leftShows = <PodcastShow>[];
    final rightShows = <PodcastShow>[];
    for (var i = 0; i < shows.length; i++) {
      if (i.isEven) {
        leftShows.add(shows[i]);
      } else {
        rightShows.add(shows[i]);
      }
    }
    return Row(
      crossAxisAlignment: .start,
      spacing: NumberConstant.gridGap,
      children: [
        Expanded(
          child: Column(
            spacing: NumberConstant.gridGap,
            children: [
              for (var i = 0; i < leftShows.length; i++)
                _buildShowCard(
                  show: leftShows[i],
                  aspectRatio: i.isEven
                      ? NumberConstant.showCardTallAspectRatio
                      : NumberConstant.showCardShortAspectRatio,
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            spacing: NumberConstant.gridGap,
            children: [
              for (var i = 0; i < rightShows.length; i++)
                _buildShowCard(
                  show: rightShows[i],
                  aspectRatio: i.isEven
                      ? NumberConstant.showCardShortAspectRatio
                      : NumberConstant.showCardTallAspectRatio,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShowCard({
    required PodcastShow show,
    required double aspectRatio,
  }) {
    final isPressed = _pressedShowId == show.id;
    return GestureDetector(
      onTap: () => _openPlayer(show),
      onTapDown: (_) => setState(() => _pressedShowId = show.id),
      onTapUp: (_) => setState(() => _pressedShowId = null),
      onTapCancel: () => setState(() => _pressedShowId = null),
      child: AnimatedScale(
        scale: isPressed ? NumberConstant.homeCardPressScale : 1,
        duration: Duration(milliseconds: NumberConstant.homeAnimFastMs),
        curve: Curves.easeOut,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: .circular(NumberConstant.cardRadius),
            child: Stack(
              fit: .expand,
              children: [
                Image.asset(show.coverImage, fit: .cover,),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: .topCenter,
                      end: .bottomCenter,
                      colors: [
                        AppColors.transparentColor,
                        AppColors.overlayGradientColor,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: NumberConstant.cardOverlayPadding,
                  right: NumberConstant.cardOverlayPadding,
                  bottom: NumberConstant.cardOverlayPadding,
                  child: Column(
                    crossAxisAlignment: .start,
                    spacing: 4,
                    children: [
                      Text(show.title, style: AppTextStyles.showTitle,),
                      Text(show.host, style: AppTextStyles.showHost,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPlayer(PodcastShow show) {
    context.push('${NamedRoutes.player.routeName}?id=${show.id}');
  }
}
