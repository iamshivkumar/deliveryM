import 'package:delivery_m/ui/customers/widgets/customer_card.dart';
import 'package:flutter/material.dart';

class CreateSubscriptionPage extends StatelessWidget {
  const CreateSubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Subscription'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: CustomerCard(),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Product',

              ),
              items: ['Milk']
                  .map(
                    (e) => DropdownMenuItem(
                      child: Row(
                        children: [
                          CircleAvatar(),
                          SizedBox(width: 16),
                          Text(e),
                          Spacer(),
                          Text('\$100')
                        ],
                      ),
                      value: e,
                    ),
                  )
                  .toList(),
              onChanged: (v) {},
            ),
            SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              onTap: () {showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    Duration(days: 30),
                  ),
                );
                
              },
              decoration: InputDecoration(
                labelText: 'Start Date',
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              items: ['Daily']
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    Duration(days: 30),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'End Date',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
