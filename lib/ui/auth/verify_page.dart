import 'package:delivery_m/ui/home/home_page.dart';
import 'package:delivery_m/ui/start/start_page.dart';
import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AspectRatio(aspectRatio: 2),
          TextField(
            decoration: InputDecoration(
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
            },
            child: Text(Labels.verify),
          ),
        ],
      ),
    );
  }
}