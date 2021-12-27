import 'package:delivery_m/ui/deliveries/delivery_page.dart';
import 'package:flutter/material.dart';

class DeliveryCard extends StatelessWidget {
  const DeliveryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryPage(),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(),
              title: Text('Customer Name'),
              subtitle: Text('A50, Saiful, Solapur'),
            ),
            Transform.translate(
              offset: Offset(0, -8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [1, 2, 3, 4, 5]
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Chip(
                              label: RichText(
                                text: TextSpan(
                                  text: 'Water Jar:  ',
                                  style: style.caption,
                                  children: [
                                    TextSpan(
                                      text: '1',
                                      style: style.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                              avatar: CircleAvatar(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
