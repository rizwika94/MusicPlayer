import 'package:flutter/material.dart';
import 'package:walkman_music/navigation/routes.dart';
import 'package:walkman_music/screens/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WalkMan",
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(),
      onGenerateRoute: Router.generateRoute,
    );
  }
}
