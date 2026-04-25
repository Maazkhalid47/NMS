import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    int totalTasks = 12;
    int completedTasks = 9; // Example
    double completionPercentage = completedTasks / totalTasks;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Icon(Icons.menu_rounded,color: Colors.black,),
            SizedBox(width: 19.5,),
            Text('WorkSpace',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 25,fontFamily: 'Inter'),)
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SingleChildScrollView(
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
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.arrow_back_ios, size: 14, color: Colors.black87),
                const SizedBox(width: 5),
                const Text(
                  "ALL PROJECTS",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Internal Projects",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Icon(Icons.more_vert, color: Colors.black),
              ],
            ),
            const Text(
              '12 active items • Last updated 2h ago',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    LayoutBuilder(
                        builder:( context, constraints){
                          return AnimatedContainer(duration: Duration(milliseconds: 400),height: 3.4,
                          width: constraints.maxWidth * completionPercentage,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25,),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [const Icon(Icons.filter_list, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      const Text("PRIORITY", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.90), borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [const Icon(Icons.calendar_month_rounded, color: Colors.black, size: 16),
                      const SizedBox(width: 8),
                      const Text("DUE DATE", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView(
                children: [
                  _taskListItem("HIGH", "O.S Infrastructure Audit & Security Scaling", "Oct 24", "3", Colors.red, false),
                  _taskListItem("MEDIUM", "Brand Guidelines V2 Distribution", "Oct 24", null, Colors.blue, false),
                  _taskListItem(null, "Review annual performance metrics", "Done", null, Colors.grey, true),
                  _taskListItem("LOW", "Update team bio for website redesign", "Nov 02", null, Colors.green.shade900, false),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  Widget _taskListItem(String? priority, String title, String date, String? comments, Color priorityColor, bool isChecked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isChecked ? Colors.grey.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20, width: 20,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(4),
              color: isChecked ? Colors.black : Colors.transparent,
            ),
            child: isChecked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (priority != null)
                  Row(
                    children: [
                      Container(height: 5, width: 5, decoration: BoxDecoration(color: priorityColor, shape: BoxShape.circle)),
                      const SizedBox(width: 5),
                      Text(priority, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: priorityColor)),
                    ],
                  ),
                const SizedBox(height: 5),
                Text(title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: isChecked ? TextDecoration.lineThrough : null,
                      color: isChecked ? Colors.black26 : Colors.black,
                    )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 12, color: Colors.black26),
                    const SizedBox(width: 5),
                    Text(date, style: const TextStyle(fontSize: 11, color: Colors.black26)),
                    if (comments != null) ...[
                      const SizedBox(width: 15),
                      const Icon(Icons.chat_bubble_outline, size: 12, color: Colors.black26),
                      const SizedBox(width: 5),
                      Text(comments, style: const TextStyle(fontSize: 11, color: Colors.black26)),
                    ]
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
