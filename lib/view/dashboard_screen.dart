import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:software_management/view_model/dashboard_view_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _taskController = TextEditingController();

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    DateTime? selectedDate;
    String selectedPriority = 'medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Add New Task"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Task Title",hintStyle: TextStyle(color: Colors.black87)),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(hintText: "Description",hintStyle: TextStyle(color: Colors.black87)),
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: Text(
                    selectedDate == null
                        ? "Select Due Date"
                        : "Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                  ),
                  trailing: const Icon(Icons.calendar_month_outlined),
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
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: const  Color(0xffF5F5F5),
                  value: selectedPriority,
                  items: ['low', 'medium', 'high']
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (val) =>
                      setDialogState(() => selectedPriority = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel",style: TextStyle(color: Colors.black),),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(18),
                ),
                elevation: 0
              ),
              onPressed: () async {
                if (titleController.text.isNotEmpty && selectedDate != null) {
                  final vm = context.read<DashboardViewModel>();
                  final now = DateTime.now();
                  final finalDateTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    now.hour,
                    now.minute,
                    now.second,
                  );
                  await vm.createNewTask(
                    title: titleController.text,
                    workspaceId: vm.selectedWorkspaceId!,
                    description: descController.text,
                    priority: selectedPriority,
                    dueDate: finalDateTime.toIso8601String(),
                  );
                  Navigator.pop(context);
                } else if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a Date")),
                  );
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DashboardViewModel>().getWorkspaces());
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Color getPriorityColor(String? priority) {
    final p = priority?.trim().toLowerCase() ?? "";

    if (p == 'high') return Colors.red;
    if (p == 'medium') return Colors.orange;
    if (p == 'low') return Colors.green;

    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F5F5),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        leading: const Icon(Icons.menu, color: Colors.black),
        title: PopupMenuButton<String>(
          onSelected: (String id) => viewModel.selectWorkspaces(id),
          itemBuilder: (context) => viewModel.workspaces.map((ws) {
            return PopupMenuItem<String>(value: ws.id, child: Text(ws.name));
          }).toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                viewModel.isLoading
                    ? "Loading..."
                    : viewModel.selectedWorkspaceName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 0.1,
                ),
              ),
              SizedBox(width: 5),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 22,
              ),
              Spacer(),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
        actions: [const SizedBox(width: 1)],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildStatCard(
                        "PENDING",
                        viewModel.pendingCount.toString(),
                        const Color(0xFF007AFF),
                        true,
                      ),
                      const SizedBox(width: 15),
                      _buildStatCard(
                        "COMPLETED",
                        viewModel.completedCount.toString(),
                        Colors.grey,
                        false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  const Text(
                    "Today's Focus",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: viewModel.tasks.isEmpty
                        ? const Center(
                            child: Text("No tasks found. Click + to add"),
                          )
                        : ListView.builder(
                            itemCount: viewModel.tasks.length,
                            itemBuilder: (context, index) {
                              final task = viewModel.tasks[index];
                              return Dismissible(key: Key(task.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.delete_forever_outlined,color: Colors.white,),
                                  ),
                                  onDismissed: (direction){
                                    viewModel.deleteTask(task.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("${task.title} deleted")),
                                    );
                                  },
                                child: Card(
                                  color: const Color(0xffF9F9FB),
                                  shadowColor: Colors.grey,
                                  elevation: 0.5,
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.circle,
                                      color: getPriorityColor(task.priority),
                                      size: 14,
                                    ),
                                    title: Text(
                                      task.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(task.description ?? "No description"),
                                    trailing: Text(
                                      formatDate(task.dueDate),
                                      style: const TextStyle(fontSize: 10, color: Colors.black87),
                                    ),
                                  ),
                                ),
                              );
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
              const SnackBar(content: Text("Please select a workspace first!")),
            );
          }
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
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
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: tagColor, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
          const Text(
            "WEEKLY GOAL",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const Text(
            "You're nearly there.",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
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
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? Colors.black : Colors.black26),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
Color getPriorityColor(String? priority) {
  if (priority == null) return Colors.blue;
  switch (priority.trim().toLowerCase()) {
    case 'high':
      return Colors.red;
    case 'medium':
      return Colors.orange;
    case 'low':
      return Colors.green;
    default:
      return Colors.blue;
  }
}
String formatDate(String dateString){
  try{
    DateTime dateTime = DateTime.parse(dateString);

    return DateFormat('yMMMd').add_jm().format(dateTime);
  }catch(e){
    return dateString;
  }
}