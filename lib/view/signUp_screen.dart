import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_management/view/bottom_nav_bar.dart';
import 'package:software_management/view/dashboard_screen.dart';
import 'package:software_management/view/logIn_screen.dart';
import 'package:software_management/view/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();


  static const String routeName = "/signup";
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  Future<void> signUpUser(String email, String password, String name) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name,}
      );
      if (response.user != null) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomNavBar()), (route) => false);
      }
    } on AuthException catch (error){
      print("Auth Error: ${error.message}");
    } catch (e) {
      print("Unexpected Error: $e");
    }
  }
  bool _isObscured = true;
  bool _isConfirmObscured = true;

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
                const SizedBox(height: 60),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Create\nAccount", style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800,color: Colors.black, height: 1.1, fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 50,),
                const Text('Build your precious workspace and\nreclaim your focus',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black, height: 1.1, fontFamily: 'Inter',
                ),),
                const SizedBox(height: 55),
                const Text("FULL NAME", style: _labelStyle),
                Container(
                  decoration: _fieldUnderline(),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) => value!.isEmpty ? 'Enter your name': null,
                    decoration: const InputDecoration(
                      hintText: "John Doe",
                      prefixIcon: Icon(
                        Icons.person_outline_outlined,
                        size: 20,
                        color: Colors.black87,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("EMAIL ADDRESS", style: _labelStyle),
                Container(
                  decoration: _fieldUnderline(),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "name@workspace.com",
                      prefixIcon: Icon(Icons.email_outlined, size: 20, color: Colors.black87,),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("PASSWORD", style: _labelStyle),
                Container(
                  decoration: _fieldUnderline(),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) => value!.length < 8 ? 'Your password is too short': null,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      prefixIcon: const Icon(Icons.lock_outline, size: 20, color: Colors.black87,),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18,),
                        onPressed: () => setState(() => _isObscured = !_isObscured),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("CONFIRM PASSWORD", style: _labelStyle),
                Container(
                  decoration: _fieldUnderline(),
                  child: TextFormField(
                    controller: confirmPasswordController,
                    validator: (value) {
                      if(value != passwordController.text) return 'Passwords do not match';
                      return null;
                    },
                    obscureText: _isConfirmObscured,
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      prefixIcon: const Icon(Icons.lock_reset_outlined, size: 20, color: Colors.black54,),
                      suffixIcon: IconButton(icon: Icon(_isConfirmObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18,),
                        onPressed: () => setState(() => _isConfirmObscured = !_isConfirmObscured,),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 99),
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF007AFF), Color(0xFF003D7A)],
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
                        if (_formKey.currentState!.validate()){
                        await signUpUser(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            nameController.text.trim());
                      }
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final name = nameController.text.trim();
        
                        if (email.isEmpty || password.isEmpty || name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("All fields are required!")));
                          return;
                        }
                        await signUpUser(email, password, name);
                      },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("SIGN UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
                        SizedBox(width: 10,),
                        Icon(Icons.login,color: Colors.white,)
                      ],
                    )
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member? ",style: TextStyle(color: Colors.grey, fontSize: 14,fontWeight: FontWeight.bold),),
                    const SizedBox(width: 2),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: const Text("Back to Login", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13,),),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
  static const TextStyle _labelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
    letterSpacing: 1.0,
  );
  BoxDecoration _fieldUnderline() {
    return const BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.black12, width: 1.5)),
    );
  }
}