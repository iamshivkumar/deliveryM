import 'package:delivery_m/ui/home/widgets/drawer.dart';
import 'package:delivery_m/ui/home/widgets/my_calendar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          MyCalendar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(4),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              AnaCard(),
                              AnaCard(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              AnaCard(),
                              AnaCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Shivkumar Konade',
                            style: style.subtitle2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              AnaCard(),
                              AnaCard(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              AnaCard(),
                              AnaCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
