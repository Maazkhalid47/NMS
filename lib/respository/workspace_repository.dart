import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/workspace_model.dart';

class WorkspaceRepository {
  final _supabase = Supabase.instance.client;

  Future<List<WorkspaceModel>> fetchWorkspaces() async{
    final user = _supabase.auth.currentUser;
    if(user == null) return [];

    final response = await _supabase.from('workspaces').select().eq('user_id', user.id);

    return (response as List).map((e) => WorkspaceModel.fromMap(e)).toList();
  }
  Future<void> createWorkspaces(String name) async {
    final user = _supabase.auth.currentUser;

    if(user != null){
      await _supabase.from('workspaces').insert({
        'name': name,
        'user_id': user.id,
      });
    }else{
      throw Exception("User is not logged in!");
    }
  }
}