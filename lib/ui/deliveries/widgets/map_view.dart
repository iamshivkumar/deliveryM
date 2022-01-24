import 'package:flutter/material.dart';


class MapView extends StatelessWidget {
  const MapView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen.shade100,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: DeliveryCard(
          //         deliveryStat: ,
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
