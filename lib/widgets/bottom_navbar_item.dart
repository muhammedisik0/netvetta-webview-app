import 'package:flutter/material.dart';

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.icon,
    required this.text,
    this.child,
    this.fontSize,
    this.iconSize,
  });

  final Function() onTap;
  final bool isSelected;
  final IconData icon;
  final String text;
  final Widget? child;
  final double? fontSize;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: child ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize ?? 22,
                color: isSelected ? Colors.black : Colors.black45,
              ),
              const SizedBox(height: 3),
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize ?? 14,
                  color: isSelected ? Colors.black : Colors.black45,
                ),
              ),
            ],
          ),
    );
  }
}
