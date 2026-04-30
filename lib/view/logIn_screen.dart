import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:software_management/view/bottom_nav_bar.dart';
import 'package:software_management/view/dashboard_screen.dart';
import 'package:software_management/view/profile_screen.dart';
import 'package:software_management/view/signUp_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

import '../view_model/dashboard_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();


  static const String routeName = "/login";
}
class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> SignInUser(String email, String password) async {
    try {
      setState(() => isLoading = true);
      final response = await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password
      );
      if (response.user != null) {
        print("Login Successful");
        await Provider
            .of<DashboardViewModel>(context, listen: false)
            .getWorkspaces();
      }
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()));
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)));
    } catch (e) {
      print('Unexpected Error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const Text("Login", style: TextStyle(fontFamily: 'Inter',
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,)),
                const SizedBox(height: 4),
                Container(
                  width: 45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 60),
                const Text("EMAIL ADDRESS", style: TextStyle(fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                  letterSpacing: 1.2,)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value){
                      if(value == null || value.isEmpty) return 'Writing an email is essential ';
                      if(!value.contains('@')) return 'Please enter a valid email address';
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "name@workspace.io",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("PASSWORD", style: TextStyle(fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                      letterSpacing: 1.2,),),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: passwordController,
                      validator: (value){
                        if(value == null || value.isEmpty) return 'Please enter your password';
                        if(value.length < 8) return 'Your password must contain at least 8 characters';
                        return null;
                      },
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      hintStyle: const TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility_off_outlined : Icons
                              .visibility_outlined, color: Colors.black54,
                          size: 20,),
                        onPressed: () =>
                            setState(() => _isObscured = !_isObscured),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text(
                                "Enter your email first, then request a reset link")));
                      } else {
                        _handleForgotPassword(emailController.text.trim());
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "FORGOT?",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 120),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF007AFF).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF003D7A), Color(0xFF007AFF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            if (email.isNotEmpty && password.isNotEmpty) {
                              await SignInUser(email, password);
                            } else {
                              print("Please,Enter Email or Password");
                            }
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.login_sharp, size: 18,
                              color: Colors.white,),
                            SizedBox(width: 7,),
                            const Text("Log In", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text("OR", style: TextStyle(color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),),),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.fingerprint, color: Colors.black54),
                    label: const Text("Use Biometric Login", style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.2),),),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),),
                      GestureDetector(
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                        // context.go(SignupScreen.routeName);
                        
                        },
                        child: const Text("Sign Up", style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _handleForgotPassword(String email) async {
    try {
      setState(() => isLoading = true);
      await Supabase.instance.client.auth.resetPasswordForEmail(email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("A password reset link has been sent to your email."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on AuthApiException catch (e) {
      String message = "Something went wrong.";

      if (e.code == 'over_email_send_rate_limit') {
        message = "Please wait a minute before requesting another link.";
      } else {
        message = e.message;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected Error: ${e.toString()}")),
        );
      }
    }finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}