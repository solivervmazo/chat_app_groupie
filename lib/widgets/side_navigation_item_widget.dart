import 'package:flutter/material.dart';

class SideNavigationItemWidget extends StatelessWidget {
  const SideNavigationItemWidget({
    super.key,
    required this.selected,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      selected: selected,
      onTap: onTap,
      selectedColor: selected ? Theme.of(context).primaryColor : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 0.0,
      ),
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
