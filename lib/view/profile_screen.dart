import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:software_management/view/logIn_screen.dart';
import 'package:software_management/view/side_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../view_model/dashboard_view_model.dart';
import '../view_model/profile_view_model.dart';
import 'components/custom_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProfileViewModel>().getUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    final profileVm = context.watch<ProfileViewModel>();
    final dashVm = context.watch<DashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: CustomAppbar(title: Text("My Profile",style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),)
      ),
      body: profileVm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => profileVm.uploadProfileImage(),
                          child: Stack(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadiusGeometry.circular(15),
                                  image: profileVm.userAvatar != null ? DecorationImage(image: NetworkImage(profileVm.userAvatar!),fit: BoxFit.cover)
                                      : null
                                ),
                                child: profileVm.userAvatar == null ? const Icon(Icons.person_outline,size: 60,color: Colors.black54,) : null,
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => profileVm.uploadProfileImage(),
                                    child: Container(
                                      height: 22.4,
                                      width: 24.5,
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.mode_edit_outline_outlined,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    )
                                  ))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text("PERSONAL PROFILE", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.black45,)),
                        const SizedBox(height: 10),
                        Text(profileVm.userName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold,),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text("Identity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 45),
                  _buildInfoRow("FULL NAME", profileVm.userName),
                  const Divider(),
                  _buildInfoRow("EMAIL ADDRESS", profileVm.userEmail),
                  const SizedBox(height: 40),
                  _buildActiveWorkspace(context),
                  const SizedBox(height: 90),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await profileVm.logout(context);
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10)
                        ),
                        side: const BorderSide(color: Colors.black12),
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12)
                      ),
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold,),),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text("Version 2.4.0-build.38", style: TextStyle(color: Colors.black54, fontSize: 10),),
                  ),
                ],
              ),
            ),
    );
  }
  Widget _buildInfoRow(String label , String value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade600, fontSize: 11)),
      const SizedBox(height: 5,),
        Text(value,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87,fontSize: 16),)
      ],
    );
  }
}
Widget _buildActiveWorkspace(BuildContext context) {
  final dashVm = context.watch<DashboardViewModel>();
  final workspaceName = dashVm.selectedWorkspaceName;

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFFF4F6F8),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("ACTIVE WORKSPACE",style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              child: const Text("PRO", style: TextStyle(fontSize: 10.3, fontWeight: FontWeight.bold)),
            ),],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Text(workspaceName.isNotEmpty ? workspaceName[0] : "W", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workspaceName.isNotEmpty ? workspaceName : "No Workspace", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if((dashVm.currentWorkspaceCollaborator ?? 0) > 0)
                  Text("${dashVm.currentWorkspaceCollaborator } Collaborator",style: const TextStyle(color: Colors.grey, fontSize: 12))
              ],
            )
          ],
        ),
      ],
    ),
  );
}
// AppBar(
// backgroundColor: Colors.grey.shade50,
// elevation: 0,
// leading: Builder(
//   builder: (context) => IconButton(
//     icon: Icon(Icons.menu, color: Colors.black),
//     onPressed: Scaffold.of(context).openDrawer,
//   ),
// ),
// title: const Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 22,),),
// actions: [const SizedBox(width: 10),
// Padding(
// padding: const EdgeInsets.only(right: 20),
// child: Container(
// height: 30,
// width: 30,
// decoration: BoxDecoration(
// color: Colors.black,
// borderRadius: BorderRadius.circular(10),
// ),
// child: const Icon(Icons.person, color: Colors.white, size: 20),
// ),
// ),],
// ),