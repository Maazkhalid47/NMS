import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:software_management/view/dashboard_screen.dart';
import 'package:software_management/view/logIn_screen.dart';
import 'package:software_management/view/bottom_nav_bar.dart';
import 'package:software_management/view/profile_screen.dart';
import 'package:software_management/view/signUp_screen.dart';
import 'package:software_management/view/splash_screen.dart';
import 'package:software_management/view/task_details_screen.dart';
import 'package:software_management/view/task_list_screen.dart';
import 'package:software_management/view_model/dashboard_view_model.dart';
import 'package:software_management/view_model/navigation_view_model.dart';
import 'package:software_management/view_model/profile_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:software_management/core/routes.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: MaterialApp.router( 
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
    ),
     );
  }
}