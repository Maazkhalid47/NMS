import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:software_management/view_model/dashboard_view_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _taskController = TextEditingController();

  void _showAddWorkspaceDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Workspace'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<DashboardViewModel>().createNewWorkspace(
                  controller.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Create"),
          ),
        ],
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

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline_outlined,
                  color: Color(0xFF007AFF),
                ),
                onPressed: () =>
                    _showAddWorkspaceDialog(),
              ),
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
        actions: [const SizedBox(width: 1),],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 30),
                  _buildAddTaskInput(viewModel),
                  const SizedBox(height: 30),
                  const Text(
                    "Today's Focus",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  viewModel.tasks.isEmpty
                      ? const Center(child: Text("No Tasks found"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: viewModel.tasks.length,
                          itemBuilder: (context, index) {
                            final task = viewModel.tasks[index];
                            return _buildTaskItem(
                              task.title,
                              viewModel.selectedWorkspaceName,
                              getPriorityColor(task.priority),
                            );
                          },
                        ),
                  const SizedBox(height: 20),
                  _buildWeeklyGoalCard(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
  Widget _buildAddTaskInput(DashboardViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: "Add a task...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_box, color: Color(0xFF005AFF), size: 30),
            onPressed: () {
              final String title = _taskController.text.trim();
              final String? wsId = vm.selectedWorkspaceId;

              if (title.isNotEmpty && wsId != null) {
                vm.createNewTask(title: title, workspaceId: wsId, description: "", priority: "medium",dueDate: DateTime.now().toIso8601String(),  );
                _taskController.clear();
                FocusScope.of(context).unfocus();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select a workspace first!"),
                  ),
                );
              }
            },
          ),
        ],
      ),
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