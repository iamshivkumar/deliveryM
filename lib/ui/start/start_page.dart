import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),
      ),
      body: ListView(
        children: [
          
        ],
      ),
    );
  }
}
