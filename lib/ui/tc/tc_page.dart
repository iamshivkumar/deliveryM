import 'package:flutter/material.dart';

class TCPage extends StatelessWidget {
  const TCPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            "First month free.\n\nIf you didn't access the service in the free trial month you can contact support.\n\nAfter the free trial month you have to pay the monthly subscription fees. Subscription fees can be vary depending on your management size in the future. If your payment fails even if the amount is deducted contact immediately. When your subscription duration or trial ends and you haven't paid again,\n   1. You as an admin can't access admin management services.\n  2. But delivery boys can access delivery services.\n  3. You are the default delivery boy. So you can continue as a delivery boy, until you pay again.\n\n"
            "We are not liable if your delivery boys cheat you while delivery and wrong billing generates as per customer.\n\n"
            "Before starting using the app, you have to train yourself and your delivery boys. You can contact support If you couldn't understand how to use the app.",
          ),
        ),
      ),
    );
  }
}
