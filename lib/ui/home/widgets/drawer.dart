import 'package:delivery_m/ui/delivery_boys/delivery_boys_page.dart';

import '../../customers/customers_page.dart';
import '../../delivery_boys/add_delivery_boys_page.dart';
import '../../products/products_page.dart';
import 'package:flutter/material.dart';

class Menu {
  final String name;
  final Widget child;

  Menu({required this.name, required this.child});
}

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);
  final List<Menu> menus = [
    Menu(name: 'Customers', child: const CustomersPage()),
    Menu(name: 'Products', child: const ProductsPage()),
    Menu(name: 'Add Delivery Boys', child: AddDeliveryBoysPage()),
    Menu(name: 'Delivery Boys', child: const DeliveryBoysPage()),

    //  Menu(name: 'Subscriptions', child: const SubscriptionsPage()),
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: menus
              .map((e) => ListTile(
                    title: Text(e.name),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => e.child));
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
