import 'package:flutter/material.dart';


class DeliveryProductWidget extends StatelessWidget {
  const DeliveryProductWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(),
          title: Text('Water Jar'),
          subtitle: Text('\$20'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '5',
                style: style.headline6,
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(0, -8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '9 Dec',
                  style: style.caption,
                ),
                Text(
                  'TO',
                  style: style.overline,
                ),
                Text(
                  '1 Jan',
                  style: style.caption,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}