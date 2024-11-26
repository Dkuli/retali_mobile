
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String primary;
  final String secondary;

  const HeaderText({
    super.key,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          primary,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        Text(
          secondary,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
        ),
      ],
    );
  }
}