import 'package:flutter/material.dart';

class EndDrawerIcon extends StatelessWidget {
  const EndDrawerIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: Scaffold.of(context).openEndDrawer, icon: Icon(icon));
  }
}
