import 'package:flutter/material.dart';

class CameraAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CameraAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Camera"),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
