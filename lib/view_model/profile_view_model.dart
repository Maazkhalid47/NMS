import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileViewModel extends ChangeNotifier{

  final _supabase = Supabase.instance.client;

  String userName = "Loading...";
  String userEmail = "Loading...";
  bool isLoading = false;
  String? userAvatar;

  Future<void> getUserProfile() async{
    isLoading = true;
    notifyListeners();
    try{
      final user = Supabase.instance.client.auth.currentUser;
      if(user != null){

        final userData = await Supabase.instance.client
            .from('users')
            .select('name')
            .eq('id', user.id)
            .single();

        userName = userData['name'] ?? "No Name";
        userEmail = user.email ?? "No Email";
        userAvatar = userData['avatar_url'];
      }
    }catch (e){
      debugPrint("Error: $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
  final ImagePicker _picker = ImagePicker();

  Future<void> uploadProfileImage() async{
    try{
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

      if(image == null) return;
      isLoading = true;
      notifyListeners();

      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final file = File(image.path);
      final fileName = '${user.id}_profile.png';
      final path = 'profile/$fileName';

      await _supabase.storage.from('avatars').upload(path, file,fileOptions: const FileOptions(upsert: true));

      final String imageUrl = _supabase.storage.from('avatar').getPublicUrl(path);
      await _supabase.from('users').update({'avatar_url': imageUrl}).eq('id', user.id);

      await getUserProfile();
    }catch(e){
      debugPrint("Upload Error: $e");
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
}