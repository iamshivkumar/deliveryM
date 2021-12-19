import 'package:flutter/material.dart';


class MyCircleButton extends StatelessWidget {
  const MyCircleButton({
    Key? key,
     this.onTap,
    required this.icon,
  }) : super(key: key);

  final Icon icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 40,
      width: 40,
      child: RawMaterialButton(
        fillColor: theme.cardColor,
        onPressed: onTap,
        shape: CircleBorder(),
        child: icon,
      ),
    );
  }
}