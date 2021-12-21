import 'package:delivery_m/ui/deliveries/deliveries_page.dart';
import 'package:delivery_m/ui/home/widgets/my_calendar.dart';
import 'package:flutter/material.dart';

import 'widgets/big_ana_card.dart';

class DeliveryBoyHomePage extends StatelessWidget {
  const DeliveryBoyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Shivkumar Konade'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveriesPage(),
            ),
          );
        },
        label: Text('Continue Deliveries'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            expandedHeight: (width / 2.8),
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: MyCalendar(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(4),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  BigAnaCard(),
                  BigAnaCard(),
                  BigAnaCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
