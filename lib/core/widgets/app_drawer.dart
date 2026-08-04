import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SafeArea(
        child: Center(
          child: Text("Coming Soon", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
