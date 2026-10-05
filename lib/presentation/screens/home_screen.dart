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

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = AppData.defaultCategory;
  late final PageController _featuredController = PageController(viewportFraction: NumberConstant.featuredCarouselViewportFraction,);

  @override
  void dispose() {
    _featuredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shows = AppData.showsForCategory(_selectedCategory);
    return Scaffold(
      backgroundColor: AppColors.gradientBottomColor,
      body: Stack(
        fit: .expand,
        children: [
          _buildBackground(),
          SafeArea(
            child: Padding(
              padding: .symmetric(horizontal: NumberConstant.horizontalPadding, vertical: NumberConstant.screenTopPadding),
              child: Column(
                crossAxisAlignment: .start,
                spacing: NumberConstant.sectionSpacing,
                children: [
                  _buildHeader(),
                _buildSectionTitle(),

                  _buildFeaturedCarousel(),
                /*  Expanded(
                    child: ListView(
                      padding: .only(bottom: NumberConstant.sectionSpacing),
                      children: [
                        Column(
                          crossAxisAlignment: .start,
                          spacing: NumberConstant.sectionSpacing,
                          children: [
                            _buildSectionTitle(),
                            _buildFeaturedCarousel(),
                            _buildCategoryChips(),
                            _buildShowsGrid(shows),
                          ],
                        ),
                      ],
                    ),
                  ),*/
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
          ),
        ),
      ],
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
          return Padding(
            padding: .only(right: NumberConstant.featuredCarouselGap),
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
        _buildDecoratedIcon(icon: AssetRes.icSearch)
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

  Widget _buildProfileAvatar() {
    return ClipOval(
      child: Image.asset(
        AssetRes.imgProfile,
        width: NumberConstant.profileImageSize,
        height: NumberConstant.profileImageSize,
        fit: .cover,
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      spacing: NumberConstant.chipSpacing,
      children: [
        const Text(StringConst.podcastForYou, style: AppTextStyles.sectionTitle,),
        SvgPicture.asset(AssetRes.icStar,),
      ],
    );
  }

  Widget _buildFeaturedCard(PodcastShow show) {
    return GestureDetector(
      onTap: () => _openPlayer(show),
      child: Container(
        height: NumberConstant.featuredCardHeight,
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
                child: Image.asset(AssetRes.nickImg)),
            Positioned(
                right: 0,
                child: Image.asset(AssetRes.johnImg)),
            Positioned(
              left: 50,
              right: 50,
              child: Column(
                mainAxisAlignment: .center,
                spacing: 10,
                children: [
                  Text(show.title, style: AppTextStyles.episodeTitle.copyWith(color: AppColors.goldColor, fontFamily: StringConst.heloTypeFontFamily),),
                  Text(show.subtitle, style: AppTextStyles.showHost, textAlign: .center,)
                ],
              ),
            )
          ],
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.whiteColor : AppColors.chipUnselectedColor,
          borderRadius: .circular(NumberConstant.chipRadius),
        ),
        child: Padding(
          padding: .symmetric(
            horizontal: NumberConstant.chipHorizontalPadding,
            vertical: NumberConstant.chipVerticalPadding,
          ),
          child: Text(
            category,
            style: AppTextStyles.chipLabel.copyWith(
              color: isSelected ? AppColors.blackColor : AppColors.whiteColor,
            ),
          ),
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
    return GestureDetector(
      onTap: () => _openPlayer(show),
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
    );
  }

  void _openPlayer(PodcastShow show) {
    context.push('${NamedRoutes.player.routeName}?id=${show.id}');
  }
}
