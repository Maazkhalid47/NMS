import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.reorder, color: Colors.black),
        title: const Text("Workspace",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(9),
                image: DecorationImage(
                  image: AssetImage(""),
                  fit: BoxFit.cover,
                ),
              ),
            )
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  const Center(child: Icon(Icons.person, size: 60, color: Colors.black54)),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black,
                      child: const Icon(Icons.edit, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text("PERSONAL PROFILE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
            const SizedBox(height: 5),
            const Text("Julian\nVance", style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, height: 1.1)),
            const SizedBox(height: 40),
            const Text("Identity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("FULL NAME",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                const SizedBox(height: 3.5,),
                Text("Julian Vance",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 10,),
            Divider(color: Colors.grey.shade300,thickness: 0.9,),
            const SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("EMAIL ADDRESS",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                const SizedBox(height: 3.5,),
                Text("julian.v@atelier.designgmail.com",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFF4F6F8),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("ACTIVE WORKSPACE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                        child: const Text("PRO", style: TextStyle(fontSize: 10.3, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                        child: const Center(child: Text("P", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Precision Atelier HD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("12 Collaborators", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: Container(
                width: 200,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.2)), // Light Red Border
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout, color: Colors.redAccent, size: 18),
                  label: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text("Version 2.4.0-build.38", style: TextStyle(color: Colors.grey, fontSize: 10)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.grid_view_rounded, color: Colors.black38),
            Icon(Icons.list_alt_rounded, color: Colors.black38),
            Icon(Icons.folder_open_rounded, color: Colors.black38),
            Icon(Icons.person, color: Colors.black),
          ],
        ),
      ),
    );
  }
  }
