import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
    final Widget title;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppbar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffF5F5F5),
      elevation: 0,
      centerTitle: false,
      shape: RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(25),
      ),
      leading: leading,
      title: title,
      actions: actions,
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}