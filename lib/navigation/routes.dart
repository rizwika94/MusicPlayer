import 'package:flutter/cupertino.dart';
import 'package:walkman_music/screens/home_screen.dart';

class MusicPlayerRoutes {
  static const home = "/home";
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MusicPlayerRoutes.home:
      default:
        {
          return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  HomeScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) => child);
        }
    }
  }
}
