
import 'package:software_management/view/login_screen.dart';
import 'package:software_management/view/signup_screen.dart';
import 'package:software_management/view/dashboard_screen.dart';
import 'package:software_management/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Define routes
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: SignupScreen.routeName,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: DashboardScreen.routeName,
      builder: (context, state) => DashboardScreen(),
    )
  ],
);