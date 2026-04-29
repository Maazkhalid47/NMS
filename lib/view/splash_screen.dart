import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_management/view/logIn_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }
  Future<void> _checkAuth() async{
    await Future.delayed(Duration(seconds: 2));

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
      backgroundColor: Color(0xFFF8F9FC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics, size: 80, color: Colors.black),
            const SizedBox(height: 16),
            const Text('NESTWARE', style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1,)),
            const Text('Your Tasks, Simplified', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500,),),
          ],
        ),
      ),
    );
  }
}
