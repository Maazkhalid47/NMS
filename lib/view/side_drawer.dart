import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.grey.shade800.withOpacity(0.05)),
                  child: Row(
                    children: [
                      Container(
                        padding: const  EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.rocket_launch,color: Colors.purpleAccent,),
                      ),
                      const SizedBox(width: 15,),
                      const Text("Whatever",style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),)
                    ],
                  ),
              ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 15 ,vertical: 10),
          child: TextField(
            style: const TextStyle(color: Colors.black54,),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              hintText: 'Search..',
              hintStyle: const TextStyle(color: Colors.grey,fontSize: 16),
              prefixIcon: Icon(Icons.search,color: Colors.grey,size: 20,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(
                color: Colors.white,
                width: 1.5
              ))
            ),
          ),
          ),
          _buildDrawerItem(Icons.home_filled, "Home", true, () {}),
          _buildDrawerItem(Icons.notifications_none, "Notification", true, () {}),
          _buildDrawerItem(Icons.task_alt_rounded, "Everything", true, () {}),

          const Divider(color: Colors.white10,indent: 20,endIndent: 20,),
          
          const Padding(padding: EdgeInsets.only(left: 20,right: 10,bottom: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("FAVORITES",style: TextStyle(color: Colors.black87,fontSize: 10,fontWeight: FontWeight.bold),),
          ),
          ),
          _buildDrawerItem(Icons.star_border, "Personal Tasks", false, () {}),

          const Spacer(),

          const Divider(color: Colors.white10,),
          _buildDrawerItem(Icons.settings_outlined, "Settings", false, () {}),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }
  Widget _buildDrawerItem(IconData icon,String title, bool isActive,VoidCallback onTap){
    return ListTile(
      leading: Icon(icon,color: isActive ? Colors.black54 : Colors.black87,size: 20,),
      title: Text(title, style: TextStyle(color: isActive ? Colors.grey.shade700 : Colors.grey.shade700,
      fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
        fontSize: 15
      )),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
      tileColor: isActive ? Colors.grey.withOpacity(0.05) : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
    );
  }
}
