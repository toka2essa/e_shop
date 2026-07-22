import 'package:eshop_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';

import '../../presentation/screens/welcome_screen.dart';

abstract class AppPages{

static Map<String, WidgetBuilder> routes = {
AppRoutes.welcome: (_) => const WelcomeScreen()

};}

