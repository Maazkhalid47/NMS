  import 'dart:ui';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  import 'package:intl/intl.dart';
  import 'package:provider/provider.dart';
import 'package:software_management/model/workspace_model.dart';
  import 'package:software_management/view/task_details_screen.dart';
  import 'package:software_management/view_model/dashboard_view_model.dart';

import 'components/custom_appbar.dart';

  class DashboardScreen extends StatefulWidget {
    const DashboardScreen({super.key});

    @override
    State<DashboardScreen> createState() => _DashboardScreenState();


  static const String routeName = "/dashboard";
  }

  final GlobalKey<PopupMenuButtonState<String>> _menuKey = GlobalKey();

  class _DashboardScreenState extends State<DashboardScreen> {
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
                        const Text("Add New Task",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                        fillColor: Colors.white38,
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
                            const Icon(Icons.calendar_month_outlined, size: 20, color: Colors.black38),
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
                                  final finalDateTime = selectedDate!;
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
    void initState() {
      super.initState();
      Future.microtask(() => context.read<DashboardViewModel>().getWorkspaces());
    }
    void _showCreateWorkspaceSheet(BuildContext context) {
      final nameController = TextEditingController();
      final descController = TextEditingController();

      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Create a Space", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                  ]
                ),
                const Text("A Space represents teams or projects, each with its own tasks.", style: TextStyle(color: Colors.black54, fontSize: 13),),
                const SizedBox(height: 25),
                const Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "e.g. Marketing, Engineering",
                    filled: true,
                    fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF7B68EE), width: 2),
                    )
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Description (optional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.grey)),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    hintText: "What is this space for?",
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF7B68EE), width: 2),
                      )
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (nameController.text.isNotEmpty) {
                            await context
                                .read<DashboardViewModel>()
                                .createNewWorkspace(nameController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("CREATE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    void _showEditWorkspaceDialog(WorkspaceModel ws){
      final editController = TextEditingController();

      showDialog(context: context,
          builder: (context) => AlertDialog(
        title: const Text("Edit Workspace",),
        content: TextField(
          controller: editController,
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
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11.5)
                  )
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11.5),
                  )
                ),
                onPressed: () async {
                  if (editController.text.isNotEmpty) {
                    await context.read<DashboardViewModel>().updateWorkspace(ws.id, editController.text);
                    setState(() {});
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text("Update",style: TextStyle(color: Colors.white),),
              ),
            ],
      ), );
    }
    void _confirmDeleteWorkspace(WorkspaceModel ws){
      final confirmController = TextEditingController();

      showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text("Delete Workspace?", style: TextStyle(color: Colors.red),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure (${ws.name}) you want to delete?\n All its tasks will also be deleted.",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
            const SizedBox(height: 15,),
            const Text("To confirm, please enter the workspace name.",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold)),
            const SizedBox(height: 5,),
            TextField(
              controller: confirmController,
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
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11.5)
              )
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.5)
            )
            ),
            onPressed: () async {
              if (confirmController.text.trim() == ws.name.trim()) {
                await context.read<DashboardViewModel>().deleteWorkspace(ws.id);
                setState(() {});
                if (mounted) Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Name does not match.")),
                );
              }
            },
            child: const Text("Yes, Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ));
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
        appBar: CustomAppbar(
          leading: IconButton(
            icon: const Icon(Icons.add_outlined, color: Colors.black),
            onPressed: () => _showCreateWorkspaceSheet(context),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PopupMenuButton<String>(
                  key: _menuKey,
                  offset: const Offset(0, 45),
                  onSelected: (String value) {
                    viewModel.selectWorkspaces(value);
                  },
                  itemBuilder: (context) {
                    return viewModel.workspaces
                        .map((ws) => PopupMenuItem<String>(value: ws.id, child: Text(ws.name)))
                        .toList();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          viewModel.isLoading ? "Loading..." : viewModel.selectedWorkspaceName,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    ],
                  ),
                ),
              ),
              if (viewModel.workspaces.isNotEmpty)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (String value) {
                    final selectedWorkspace = viewModel.workspaces.firstWhere(
                          (ws) => ws.id == viewModel.selectedWorkspaceId,
                    );

                    if (value == 'edit') {
                      _showEditWorkspaceDialog(selectedWorkspace);
                    } else if (value == 'delete') {
                      _confirmDeleteWorkspace(selectedWorkspace);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit Workspace'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        body: viewModel.isLoading ? const Center(child: CircularProgressIndicator()) : viewModel.workspaces.isEmpty ? _buildEmptyState(context) : _buildDashboardContent(viewModel),
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
    Widget _buildEmptyState(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny_outlined, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("No WorkSpace Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            TextButton(
              onPressed: () => _showCreateWorkspaceSheet(context),
              child: const Text("Create your Workspace"),
            ),
          ],
        ),
      );
    }
    Widget _buildDashboardContent(DashboardViewModel viewModel) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard("PENDING", viewModel.pendingCount.toString(), const Color(0xFF007AFF), true,),
                const SizedBox(width: 15),
                _buildStatCard("COMPLETED", viewModel.completedCount.toString(), Colors.grey,false,),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Today's Focus", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const SizedBox(height: 10),
            Expanded(
              child: viewModel.tasks.isEmpty
                  ? const Center(child: Text("No tasks found. Click + to add"))
                  : ListView.builder(
                itemCount: viewModel.tasks.length,
                itemBuilder: (context, index) {
                  if (index >= viewModel.tasks.length) return const SizedBox.shrink();
                  final task = viewModel.tasks[index];
                  return Dismissible(key: Key(task.id),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                        ),
                        child: const Icon(Icons.delete_outline_outlined,color: Colors.white,),
                      ),
                      onDismissed: (direction){
                    viewModel.deleteTask(task.id);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Task Deleted")),);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailsScreen(task: task),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Icon(Icons.circle_rounded, color: getPriorityColor(task.priority), size: 14),
                            title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Text(task.description ?? "No description", maxLines: 1, overflow: TextOverflow.ellipsis,),
                            trailing: const Icon(Icons.chevron_right_sharp, color: Colors.black54),
                          ),
                        ),
                          ),
                  );
                      },
                    ),
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
            borderRadius: BorderRadius.circular(15),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10,),] : null,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey,),),
              const SizedBox(height: 5),
              Text(count, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }