import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final EdgeInsetsGeometry margin;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.margin = EdgeInsets.zero,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.search, color: Color.fromARGB(255, 78, 29, 87)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }
}
