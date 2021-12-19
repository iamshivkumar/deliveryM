import 'package:delivery_m/utils/labels.dart';
import 'package:flutter/material.dart';

import 'widgets/my_circle_button.dart';

class PickAddressPage extends StatelessWidget {
  const PickAddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomSheet: Material(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: Labels.houseFlatBlockNo,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Area',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: Labels.cityVillage,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: () {}, child: Text('CONTINUE'))
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.lightGreen[100],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: MyCircleButton(
                      icon: Icon(
                        Icons.arrow_back,
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Card(
                      shape: StadiumBorder(),
                      child: SizedBox(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Search Your Location'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: MyCircleButton(
                      icon: Icon(
                        Icons.layers_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
