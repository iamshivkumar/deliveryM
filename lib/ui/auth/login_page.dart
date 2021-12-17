import 'package:delivery_m/ui/auth/verify_page.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AspectRatio(aspectRatio: 2),
          TextField(
            decoration: InputDecoration(
              prefixText: '+91 ',
              prefixIcon: Icon(Icons.call),
              
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyPage(),
                ),
              );
            },
            child: Text(Labels.continueLabel),
          ),
        ],
      ),
    );
  }
}
