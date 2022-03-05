import 'package:delivery_m/utils/assets.dart';
import 'package:flutter/material.dart';

class LogoTitle extends StatelessWidget {
  const LogoTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 48,
          width: 48,
          child: ClipRRect(
            child: Image.asset(Assets.logo),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const Text('Delyman'),
        const SizedBox(width: 12)
      ],
    );
  }
}
