import 'package:flutter/material.dart';

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
    required this.isSelected,
  });

  final Function() onTap;
  final IconData icon;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? Colors.black : Colors.black45,
          ),
          const SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
