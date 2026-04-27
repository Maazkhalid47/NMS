import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();


  static const String routeName = "/task_details"; 
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text("Workspace", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(backgroundColor: Color(0xFF4A4A4A), radius: 15),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text("TASK TITLE", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Architecture\nReview: Core API\nv2", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, height: 1.2)),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    color: const Color(0xFFF8F8F8),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("STATUS", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        SizedBox(height: 10),
                        Row(children: [Icon(Icons.circle_outlined, size: 14), SizedBox(width: 8), Text("Pending", style: TextStyle(fontSize: 12))]),
                        SizedBox(height: 8),
                        Row(children: [Icon(Icons.check_circle, size: 14, color: Colors.blue), SizedBox(width: 8), Text("In Progress", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
                        SizedBox(height: 8),
                        Row(children: [Icon(Icons.circle_outlined, size: 14), SizedBox(width: 8), Text("Completed", style: TextStyle(fontSize: 12))]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    color: const Color(0xFFF8F8F8),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("PRIORITY", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        SizedBox(height: 10),
                        Row(children: [Icon(Icons.circle_outlined, size: 14), SizedBox(width: 8), Text("Low", style: TextStyle(fontSize: 12))]),
                        SizedBox(height: 8),
                        Row(children: [Icon(Icons.circle_outlined, size: 14), SizedBox(width: 8), Text("Medium", style: TextStyle(fontSize: 12))]),
                        SizedBox(height: 8),
                        Row(children: [Icon(Icons.check_circle, size: 14, color: Colors.blue), SizedBox(width: 8), Text("High", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DATE ASSIGNED", style: TextStyle(fontSize: 11, color: Colors.black45)),
                    SizedBox(height: 4),
                    Text("Oct 24, 2023", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(width: 120),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DUE DATE", style: TextStyle(fontSize: 11, color: Colors.black45)),
                    SizedBox(height: 5),
                    Text("11/18/2023", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("DESCRIPTION", style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Review the proposed schema changes for the core API v2.\n- Ensure backward compatibility for legacy endpoints.\n- Validate rate-limiting logic on high-frequency routes.\n- Verify security headers and JWT validation middleware.",style: TextStyle(fontSize: 16.6, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF007BFF),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Center(
            child: Text("SAVE CHANGES",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}