import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_management/view/logIn_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isObscured = true;
  bool _isConfirmObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SingleChildScrollView(
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
              const Text("Create\nAccount", style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold,color: Colors.black, height: 1.1, fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 50,),
              const Text('Build your precious workspace and\nreclaim your focus',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black, height: 1.1, fontFamily: 'Inter',
              ),),
              const SizedBox(height: 55),
              const Text("Username", style: _labelStyle),
              Container(
                decoration: _fieldUnderline(),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Username",
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: 20,
                      color: Colors.black45,
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
                  decoration: const InputDecoration(
                    hintText: "Email address",
                    prefixIcon: Icon(Icons.email_outlined, size: 20, color: Colors.black45,),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("PASSWORD", style: _labelStyle),
              Container(
                decoration: _fieldUnderline(),
                child: TextFormField(
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    prefixIcon: const Icon(Icons.lock_outline, size: 20, color: Colors.black45,),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, size: 18,),
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
                  obscureText: _isConfirmObscured,
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    prefixIcon: const Icon(Icons.lock_reset_outlined, size: 20, color: Colors.black45,),
                    suffixIcon: IconButton(icon: Icon(_isConfirmObscured ? Icons.visibility_off : Icons.visibility, size: 18,),
                      onPressed: () => setState(() => _isConfirmObscured = !_isConfirmObscured,),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),
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
                  onPressed: () {
                    // Sign up logic yahan aayegi
                  },
                  child: const Text("SIGN UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member? ",style: TextStyle(color: Colors.grey, fontSize: 13),),
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