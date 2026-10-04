import 'package:go_router/go_router.dart';
import 'package:podcast_ui/presentation/screens/home_screen.dart';
import 'package:podcast_ui/presentation/screens/player_screen.dart';
import 'package:podcast_ui/presentation/screens/welcome_screen.dart';

GoRouter router = GoRouter(
  initialLocation: NamedRoutes.welcome.routeName,
  routes: [
    GoRoute(path: NamedRoutes.welcome.routeName, builder: (ctx, state) => const WelcomeScreen(),),
    GoRoute(path: NamedRoutes.home.routeName, builder: (ctx, state) => const HomeScreen(),),
    GoRoute(path: NamedRoutes.player.routeName, builder: (ctx, state) => const PlayerScreen(),),
  ],
);

enum NamedRoutes {
  welcome('/welcome'),
  home('/home'),
  player('/player');

  final String routeName;
  const NamedRoutes(this.routeName);
}
