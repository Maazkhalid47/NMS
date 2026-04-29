import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:software_management/view/logIn_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
static const String routeName = "/splash";

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async{
    await Future.delayed(Duration(microseconds: 300));

    final session = Supabase.instance.client.auth.currentSession;

    if(!mounted) return;

    if(session != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavBar()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Icon(Icons.rocket_launch, size: 80, color: Colors.black)),
          Center(child: Text('Splash\nScreen',style: TextStyle(color: Colors.black54,fontSize: 20,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.abel.toString()),))
        ],
      ),
    );
  }
}
