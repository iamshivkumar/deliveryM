import 'package:flutter/material.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions'),
      ),
      body: ListView(
        padding: EdgeInsets.all(4),
        children: [
          SubscriptionCard(),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
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
              padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Customer Name',style: style.bodyText1,),
                  ),
                  Text('Area')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Product Name'),
                  ),
                  Text('\$100',style: style.subtitle2,)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  Container(
                    height: 4,
                    color: theme.dividerColor,
                  ),
                  Container(
                    width: 100,
                    height: 4,
                    color: Colors.green,
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
