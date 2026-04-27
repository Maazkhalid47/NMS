import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();


  static const String routeName = "/dashboard";
}

class _DashboardScreenState extends State<DashboardScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
        title: const Row(
          children: [
            Text("Studio X", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),),
            Icon(Icons.keyboard_arrow_down, color: Colors.black),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(""),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatCard("PENDING", "12", const Color(0xFF007AFF), true),
                const SizedBox(width: 15),
                _buildStatCard("COMPLETED", "48", Colors.grey, false),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text("Add a task...", style: TextStyle(color: Colors.black26),),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Focus", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                Text("OCT 24, 2023", style: TextStyle(color: Colors.grey, fontSize: 12),),
              ],
            ),
            const SizedBox(height: 20),
            _buildTaskItem("Review brand identity guidelines", "HIGH PRIORITY", Colors.red,),
            _buildTaskItem("Client presentation prep", "STUDIO X", Colors.blue),
            _buildTaskItem("Invoice reconciliation", "ADMIN", Colors.grey),
            _buildTaskItem("Update design system tokens", "SYSTEMS", Colors.blueAccent,),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02),blurRadius: 10,),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 4,
                    color: const Color(0xFF007AFF).withOpacity(0.5),
                  ),
                  const SizedBox(height: 15),
                  const Text("WEEKLY GOAL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey,),),
                  const SizedBox(height: 5),
                  const Text("You're nearly there.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  const SizedBox(height: 5),
                  const Text("75% of your objectives for the 'Precision Atelier' sprint are finished.", style: TextStyle(color: Colors.grey, fontSize: 13),),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.grid_view_rounded, "HOME", true),
            _buildNavItem(Icons.list_alt_rounded, "LIST", false),
            _buildNavItem(Icons.folder_open_rounded, "FILES", false),
            _buildNavItem(Icons.person_outline_rounded, "PROFILE", false),
          ],
        ),
      ),
    );
  }
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon,color: isActive ? Colors.black : Colors.black26, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.black26, letterSpacing: 0.5,),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 15,
            height: 2,
            color: Colors.black,
          ),
      ],
    );
  }
  Widget _buildStatCard(
    String label,
    String count,
    Color color,
    bool isActive,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey,),
            ),
            const SizedBox(height: 5),
            Text(
              count,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(width: 60, height: 3, color: color),
          ],
        ),
      ),
    );
  }
  Widget _buildTaskItem(String title, String subtitle, Color tagColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle_outlined, color: Colors.black12, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14,),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold,),
                ),
              ],
            ),
          ),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: tagColor, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
