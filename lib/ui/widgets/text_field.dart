import 'package:flutter/material.dart';

class TextFieldSuffixButton extends StatelessWidget {
  const TextFieldSuffixButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(padding: const EdgeInsets.all(4), child: Icon(icon)),
    );
  }
}
