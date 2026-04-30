import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:software_management/view/components/custom_appbar.dart';
import 'package:software_management/view/side_drawer.dart';
import 'package:software_management/view_model/dashboard_view_model.dart';
import 'package:software_management/view_model/navigation_view_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../model/tasks_model.dart';
import 'dashboard_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();


  static const String routeName = "/task_list";
}

class _TaskListScreenState extends State<TaskListScreen> {
  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime? selectedDate;
    String selectedPriority = 'medium';

    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add New Task",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text("Task Title", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "What needs to be done?",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF7B68EE), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descController,
                    decoration: InputDecoration(
                      hintText: "Add more details...",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF7B68EE), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null
                                ? "Select Due Date"
                                : "Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            style: TextStyle(color: selectedDate == null ? Colors.black54 : Colors.black),
                          ),
                          const Icon(Icons.calendar_month_outlined, size: 20, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    dropdownColor: Colors.white,
                    decoration: InputDecoration(
                      labelText: "PRIORITY",
                      labelStyle: const TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF7B68EE), width: 2),
                      ),
                    ),
                    items: ['low', 'medium', 'high'].map((p) => DropdownMenuItem(
                      value: p,
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 10, color: p == 'high' ? Colors.red : p == 'medium' ? Colors.blue : Colors.green),
                          const SizedBox(width: 10),
                          Text(p[0].toUpperCase() + p.substring(1)),
                        ],
                      ),
                    )).toList(),
                    onChanged: (v) => setDialogState(() => selectedPriority = v!),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: isSaving ? null : () async {
                            if (titleController.text.isNotEmpty && selectedDate != null) {
                              setDialogState(() => isSaving = true);
                              try {
                                final vm = context.read<DashboardViewModel>();
                                final now = DateTime.now();
                                final finalDateTime = DateTime(
                                  selectedDate!.year, selectedDate!.month, selectedDate!.day,
                                  now.hour, now.minute, now.second,
                                );
                                await vm.createNewTask(
                                  title: titleController.text,
                                  workspaceId: vm.selectedWorkspaceId!,
                                  description: descController.text,
                                  priority: selectedPriority,
                                  dueDate: finalDateTime.toIso8601String(),
                                );
                                if (mounted) Navigator.pop(context);
                              } catch (e) {
                                setDialogState(() => isSaving = false);
                              }
                            }
                          },
                          child: isSaving
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text("ADD TASK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();
    final tasks = viewModel.tasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: CustomAppbar(title: Text("Tasks List",style: TextStyle(
      color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
      ),)
        ,actions: [const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: (){
                context.read<NavigationViewModel>().setIndex(0);
                if(Navigator.canPop(context)){
                  Navigator.pop(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_ios, size: 14, color: Colors.black87),
                    const SizedBox(width: 5),
                    const Text("ALL PROJECTS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  '${tasks.length} active items',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(Icons.circle, size: 4, color: Colors.black26),
                ),
                Text(
                  tasks.isEmpty ? "No updates" : "Last updated ${tasks.first.created_at.hour}h ago",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                viewModel.selectedWorkspaceName,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${tasks.length} active items',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(width: 4),
                    Text(tasks.isEmpty ? "No updates" : "Last updated ${timeago.format(tasks.first.created_at)}",
                      style: const TextStyle(fontSize: 12, color: Colors.black54),)
                  ],
                ),
              ],
            ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: Colors.black54)),
                ]
            ),
                const SizedBox(height: 20),
            Stack(
              children: [
                Container(height: 3, width: double.infinity, color: Colors.black12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 3.4,
                  width: MediaQuery.of(context).size.width * viewModel.completionPercentage,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                _buildChip("PRIORITY", Colors.black, Colors.white, Icons.filter_list),
                const SizedBox(width: 10),
                _buildChip("DUE DATE", Colors.grey.shade200, Colors.black,Icons.calendar_month_outlined),
              ],
            ),
            const SizedBox(height: 25),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text("No tasks found"))
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _taskListItem(tasks[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          if (viewModel.selectedWorkspaceId != null) {
            _showAddTaskDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a workspace first")),
            );
          }
        },
      ),
    );
  }
 Widget _buildChip(String label, Color bg, Color text,IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
          children: [
            Icon(icon, size: 14, color: text),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: text, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
    );
  }
  Widget _taskListItem(TaskModel task) {
    bool isCompleted = task.status.toLowerCase() == 'completed';

    Color pColor = task.priority.toLowerCase() == 'high' ? Colors.red
        : task.priority.toLowerCase() == 'medium' ? Colors.blue
        : Colors.green;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ], ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              height: 22, width: 22,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: isCompleted ? Colors.black : Colors.black12, width: 1.5),
              ),
              child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ), const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: pColor),
                    const SizedBox(width: 6),
                    Text(task.priority.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: pColor,letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(width: 4),
                Text(task.title,
                  style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: isCompleted ? Colors.black38 : Colors.black87,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.black38),
                    const SizedBox(width: 4),
                    Text(task.dueDate, style: const TextStyle(fontSize: 12, color: Colors.black38)),
                    const SizedBox(width: 12),
                    const Icon(Icons.chat_bubble_outline, size: 12, color: Colors.black38),
                    const SizedBox(width: 4),
                    const Text("3", style: TextStyle(fontSize: 12, color: Colors.black38)),
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