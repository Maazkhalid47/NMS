import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/tasks_model.dart';
import '../model/workspace_model.dart';
import '../respository/task_repository.dart';
import '../respository/workspace_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final WorkspaceRepository _workspaceRepo = WorkspaceRepository();
  final TaskRepository _taskRepo = TaskRepository();
  final supabase = Supabase.instance.client;

  bool _hasFetched = false;
  List<WorkspaceModel> workspaces = [];
  List<TaskModel> tasks = [];
  bool isLoading = false;
  String? _selectedWorkspaceId;

  String? get selectedWorkspaceId => _selectedWorkspaceId;

  int get pendingCount => tasks.where((t) => t.status?.toLowerCase() == 'pending').length;

  int get completedCount => tasks.where((t) => t.status?.toLowerCase() == 'completed').length;

  double get completionPercentage {
    if (tasks.isEmpty) return 0.0;
    int completed = tasks.where((t) => t.status?.toLowerCase() == 'completed').length;
    return completed / tasks.length;
  }
  String get selectedWorkspaceName {
    if (_selectedWorkspaceId == null || workspaces.isEmpty) return 'No Workspace';
    try {
      return workspaces.firstWhere((ws) => ws.id == _selectedWorkspaceId).name;
    } catch (e) {
      return 'No Workspace';
    }
  }
  Future<void> getWorkspaces() async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      workspaces = await _workspaceRepo.fetchWorkspaces();

      if (workspaces.isNotEmpty) {
        _selectedWorkspaceId = workspaces.first.id;
        tasks = await _taskRepo.fetchTasks(_selectedWorkspaceId!);
      }

        tasks = await _taskRepo.fetchTasks(_selectedWorkspaceId!);
        _hasFetched = true;
      }
    catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  void selectWorkspaces(String id) async {
    if (_selectedWorkspaceId == id) return;

    _selectedWorkspaceId = id;
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_ws_id', id);

    try {
      tasks = await _taskRepo.fetchTasks(id);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> fetchTasksForWorkspace(String workspaceId) async {
    try {
      tasks = await _taskRepo.fetchTasks(workspaceId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error Fetching Tasks: $e");
    }
  }
  Future<void> createNewTask({
    required String title,
    required String workspaceId,
    String description = "",
    String priority = "medium",
    required String dueDate,
  }) async {
    try {
      await _taskRepo.addTask(
        title: title,
        workspaceId: workspaceId,
        priority: priority,
        description: description,
        dueDate: dueDate,
      );
      await fetchTasksForWorkspace(workspaceId);
    } catch (e) {
      debugPrint("DATABASE ERROR: $e");
    }
  }
  Future<void> createNewWorkspace(String name) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    try {
      await supabase.from('workspaces').insert({
        'name': name,
        'user_id': user.id,
      });
      _hasFetched = false;
      await getWorkspaces();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskRepo.deleteTask(taskId);
      if (_selectedWorkspaceId != null) {
        await fetchTasksForWorkspace(_selectedWorkspaceId!);
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }
  int? get currentWorkspaceCollaborator {
    if (_selectedWorkspaceId == null || workspaces.isEmpty) return 0;

    return workspaces
        .firstWhere((ws) => ws.id == _selectedWorkspaceId)
        .collaborator;
  }
  Future<void> updateTaskStatus(String taskId, String status) async {
    try {
      await _taskRepo.updateTaskStatus(taskId, status);
      final index = tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        tasks[index] = tasks[index].copyWith(status: status);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
    }
  }
  Future<void> updateTaskTitle(String taskId, String newTitle) async {
    try {
      await _taskRepo.updateTaskTitle(taskId, newTitle);
      final index = tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        tasks[index] = tasks[index].copyWith(title: newTitle);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Title Update Error: $e");
    }
  }
  Future<void> updateTaskPriority(String taskId, String newPriority) async{
    try{
      await _taskRepo.updateTaskPriority(taskId, newPriority);
      final index = tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        tasks[index] = tasks[index].copyWith(priority: newPriority);
        notifyListeners();
      }
    }catch(e){
      debugPrint("Error: $e");
    }
  }
  Future<void> updateTaskDescription(String taskId, String newDesc) async {
    try {
      await _taskRepo.updateTaskDescription(taskId, newDesc);
      final index = tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        tasks[index] = tasks[index].copyWith(description: newDesc);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
  void clearData(){
    workspaces = [];
    tasks = [];
    _selectedWorkspaceId = null;
    _hasFetched = false;
    notifyListeners();
  }
}