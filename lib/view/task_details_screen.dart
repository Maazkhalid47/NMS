import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as centext;
import 'package:software_management/model/task_model.dart';
import 'package:software_management/view/components/custom_appbar.dart';
import 'package:software_management/view/side_drawer.dart';
import 'package:software_management/view_model/dashboard_view_model.dart';
import 'package:provider/provider.dart';
import '../respository/task_repository.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? "");
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget statusItem(String title, bool isSelected) {
    return InkWell(
      onTap: () => context.read<DashboardViewModel>().updateTaskStatus(widget.task.id, title.toLowerCase()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: 16, color: isSelected ? Colors.black : Colors.white),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.black54)),
          ],
        ),
      ),
    );
  }
  Widget priorityItem(String pLabel, bool isSelected, Color pColor) {
    return InkWell(
      onTap: () => context.read<DashboardViewModel>().updateTaskPriority(widget.task.id, pLabel.toLowerCase()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: 16, color: isSelected ? Colors.black : Colors.white),
            const SizedBox(width: 10),
            Text(pLabel, style: TextStyle(fontSize: 13,
                color: isSelected ? Colors.black : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = context.watch<DashboardViewModel>().tasks.firstWhere(
          (t) => t.id == widget.task.id,
      orElse: () => widget.task,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: CustomAppbar(
          title: Text("Task Details",style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
         actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteDialog(),
            )
          ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel("What is to be done?"),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: currentTask.status == 'completed',
                  onChanged: (val) {
                    context.read<DashboardViewModel>().updateTaskStatus(
                        widget.task.id, val! ? 'completed' : 'pending'
                    );
                  },
                ),
                const Text("Task finished?", style: TextStyle(fontSize: 16, color: Colors.black87,)),
              ],
            ),
            const SizedBox(height: 25),
            _buildSectionLabel("Due date"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDueDate(currentTask.dueDate),
                  style: const TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.w500),
                ),
                const Icon(Icons.calendar_month_outlined, size: 20, color: Colors.black38),
              ],
            ),
            const Divider(height: 30),
            _buildSectionLabel("Description"),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Add more details...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 25,),
            _buildSectionLabel("Priority"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['low', 'medium', 'high'].map((p) {
                bool isSelected = currentTask.priority == p;
                return ChoiceChip(
                  label: Text(p.toUpperCase()),
                  selected: isSelected,
                  onSelected: (val) {
                    context.read<DashboardViewModel>().updateTaskPriority(widget.task.id, p);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.check, color: Colors.white, size: 30),
        onPressed: () {
          final vm = context.read<DashboardViewModel>();
          vm.updateTaskTitle(widget.task.id, _titleController.text);
          vm.updateTaskDescription(widget.task.id, _descriptionController.text);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Changes Saved!")),
          );
        },
      ),
    );
  }
  Widget _buildSectionLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),);
  }

  Widget _buildInputField(String label, TextEditingController controller, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        TextField(
          controller: controller,
          maxLines: null,
          style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: Colors.black),
          decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 8)),
          onSubmitted: (val) {
            if(label.contains("done")) {
              context.read<DashboardViewModel>().updateTaskTitle(widget.task.id, val);
            } else {
              context.read<DashboardViewModel>().updateTaskDescription(widget.task.id, val);
            }
          },
        )
      ],
    );
  }

  Widget _buildStatusBox(TaskModel currentTask) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("STATUS", style: TextStyle(fontSize: 10, color: Colors.black38, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 10),
        statusItem("Pending", currentTask.status == 'pending'),
        statusItem("In Progress", currentTask.status == 'in progress'),
        statusItem("Completed", currentTask.status == 'completed'),
      ],
    );
  }

  Widget _buildPriorityBox(TaskModel currentTask) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("PRIORITY", style: TextStyle(fontSize: 10, color: Colors.black38, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 10),
        priorityItem("Low", currentTask.priority == 'low', Colors.green),
        priorityItem("Medium", currentTask.priority == 'medium', Colors.blue),
        priorityItem("High", currentTask.priority == 'high', Colors.red),
      ],
    );
  }

  Widget _dateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: 5),
        Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
      ],
    );
  }

  String _formatDueDate(String date) {
    try {
      DateTime dt = DateTime.parse(date);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (e) {
      return date;
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
              const SizedBox(height: 10),

              const Text(
                "Delete Task?",
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "This action can't be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        context.read<DashboardViewModel>().deleteTask(widget.task.id);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text("Delete",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}