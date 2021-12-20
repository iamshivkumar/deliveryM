import 'package:flutter/material.dart';


class AnaCard extends StatelessWidget {
  const AnaCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Water Bottle',
                  style: style.caption,
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    Text('10'),
                    Text('/'),
                    Text('20'),
                    Text('/'),
                    Text('30'),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}