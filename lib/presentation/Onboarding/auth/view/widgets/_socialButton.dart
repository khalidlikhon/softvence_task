

import 'package:flutter/material.dart';



/// ---------------- SOCIAL BUTTON ----------------

Widget socialButton({
  required String icon,
  required VoidCallback onTap,
}) {
  return SizedBox(
    height: 50,
    width: 50,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
      ),
      child: Image.asset(icon, height: 24, width: 24),
    ),
  );
}