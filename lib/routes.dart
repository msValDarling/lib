import 'package:flutter/material.dart';
import 'package:pmsna/screen/add_post_screen.dart';
import 'package:pmsna/screen/dashboard_screen.dart';
import 'package:pmsna/screen/events_screen.dart';
import 'package:pmsna/screen/list_popular_screen.dart';
import 'package:pmsna/screen/list_post.dart';
import 'package:pmsna/screen/login_screen.dart';
import 'package:pmsna/screen/register_screen.dart';
import 'package:pmsna/screen/onboarding.dart';
import 'package:pmsna/screen/theme_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/register': (BuildContext context) => const RegisterScreen(),
    '/dash': (BuildContext context) => DashboardScreen(),
    '/login': (BuildContext context) => LoginScreen(),
    '/add': (BuildContext context) => AddPostScreen(),
    '/onboarding': (BuildContext context) => Onboarding(),
    '/theme': (BuildContext context) => ThemeScreen(),
    '/list': (BuildContext context) => ListPost(),
    '/events': (BuildContext context) => Eventos(),
    '/popular': (BuildContext context) => ListPopularVideos()
  };
}
