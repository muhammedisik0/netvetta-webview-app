import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netvetta/widgets/bottom_navbar_item.dart';

class AccountSubButtons extends StatelessWidget {
  const AccountSubButtons({
    super.key,
    required this.onPersonalButtonPressed,
    required this.onLogOutButtonPressed,
    required this.isSelected,
  });

  final Function() onPersonalButtonPressed;
  final Function() onLogOutButtonPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BottomNavBarItem(
          onTap: onPersonalButtonPressed,
          isSelected: isSelected,
          icon: FontAwesomeIcons.solidUser,
          text: 'Kişisel',
          iconSize: 16.5,
          fontSize: 10.5,
        ),
        Container(
          width: 1,
          height: 20,
          color: isSelected ? Colors.black : Colors.black45,
          margin: const EdgeInsets.symmetric(horizontal: 10),
        ),
        BottomNavBarItem(
          onTap: onLogOutButtonPressed,
          isSelected: isSelected,
          icon: FontAwesomeIcons.arrowRightFromBracket,
          text: 'Çıkış',
          iconSize: 16.5,
          fontSize: 10.5,
        ),
      ],
    );
  }
}
