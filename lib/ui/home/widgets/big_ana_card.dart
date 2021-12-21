import 'package:flutter/material.dart';


class BigAnaCard extends StatelessWidget {
  const BigAnaCard({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    final style = theme.textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(radius: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Water Jar',
                      style: style.subtitle2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivered',
                          style: style.caption,
                        ),
                        Text('10'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gave',
                          style: style.caption,
                        ),
                        Text('10'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated',
                          style: style.caption,
                        ),
                        Text('10'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending',
                          style: style.caption,
                        ),
                        Text('10'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'On the way',
                          style: style.caption,
                        ),
                        Text('10'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Should give',
                          style: style.caption,
                        ),
                        Text('10'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
