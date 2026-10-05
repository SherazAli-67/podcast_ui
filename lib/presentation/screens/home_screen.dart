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
      // backgroundColor: AppColors.gradientBottomColor,
      body: Stack(
        fit: .expand,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: .symmetric(horizontal: NumberConstant.horizontalPadding, vertical: NumberConstant.screenTopPadding),
              child: Column(
                crossAxisAlignment: .start,
                spacing: NumberConstant.sectionSpacing,
                children: [
                  _buildHeader(),
                  _buildSectionTitle(),
                  _buildFeaturedCarousel(),
                  _buildCategoryChips(),
                  _buildShowsGrid(shows),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40,
              right: 10,
              left: 10,
              child: Container(
              /*  decoration: BoxDecoration(
                  color: AppColors.currentPlayerBgColor,
                  borderRadius: .circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0,4),
                      blurRadius: 27,
                      spreadRadius: 0,
                      color: Colors.black.withValues(alpha: 0.25)
                    )
                  ]
                ),*/
                padding: .all(10),
                child: Row(
                  spacing: 10,
                  children: [
                    ClipRRect(
                      borderRadius: .circular(8),
                      //holdItImg
                      child: const SizedBox()
                    ),
                    Expanded(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        //Hold It On, screenTitle,
                        Text("", style: AppTextStyles.screenTitle,),
                        //The angry Coach Series, miniPlayerTitle
                        Text("", style: AppTextStyles.miniPlayerTitle,)
                      ],
                    )),
                    Container(
                    /*  decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: .circle
                      ),*/
                      padding: .all(15),
                      //icPlay, 24
                    )
                  ],
                ),
              ))
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
        //decoratedIcon: icDrawer
        const Expanded(
          child: Text(
            //homeTitle
            '',
            style: AppTextStyles.screenTitle,
            textAlign: .center,
          ),
        ),
        //decoratedIcon: icSearch
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
        //podcastForYour, sectionTitle,
        //icStar
      ],
    );
  }

  Widget _buildFeaturedCard(PodcastShow show) {
    return GestureDetector(
      onTap: () => _openPlayer(show),
      child: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(image: AssetImage(AssetRes.decoratedBanner), fit: .cover),
          // borderRadius: .circular(NumberConstant.cardRadius),
        ),
        clipBehavior: .hardEdge,
        child: Stack(
          alignment: .center,
          children: [
            Positioned(
                left: 0,

                //nickImg
                child: const SizedBox()
            ),
            Positioned(
                right: 0,
                //johnImg
                child: const SizedBox()
            ),
            Positioned(
              left: 50,
              right: 50,
              child: Column(
                mainAxisAlignment: .center,
                spacing: 10,
                children: [
                  //show.title, episodeTitle.with: goldColor, heloTypeFont, .center,
                  //show.subtitle, showHost, .center
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
          // color: isSelected ? AppColors.whiteColor : AppColors.whiteColor.withValues(alpha: 0.09),
          // borderRadius: .circular(NumberConstant.chipRadius),
        ),
        child: Padding(
          padding: .symmetric(
            // horizontal: NumberConstant.chipHorizontalPadding,
            // vertical: NumberConstant.chipVerticalPadding,
          ),
          //category, chipLabel, isSelected: black:unSelectedChip.76
          child: const SizedBox()
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
              // Image.asset(show.coverImage, fit: .cover,),
              const DecoratedBox(
                decoration: BoxDecoration(
                /*  gradient: LinearGradient(
                    begin: .topCenter,
                    end: .bottomCenter,
                    colors: [
                      AppColors.transparentColor,
                      AppColors.overlayGradientColor,
                    ],
                  ),*/
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
                    //show.title, showTitle,
                    //show.host, showHost
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
