import 'package:delivery_m/ui/auth/providers/auth_provider.dart';
import 'package:delivery_m/ui/delivery_boys/delivery_boys_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../customers/customers_page.dart';
import '../../delivery_boys/add_delivery_boys_page.dart';
import '../../products/products_page.dart';
import 'package:flutter/material.dart';

class Menu {
  final String name;
  final Widget child;

  Menu({required this.name, required this.child});
}

class MyDrawer extends ConsumerWidget {
  MyDrawer({Key? key}) : super(key: key);
  final List<Menu> menus = [
    Menu(name: 'Customers', child: const CustomersPage()),
    Menu(name: 'Products', child: const ProductsPage()),
    Menu(name: 'Add Delivery Boys', child: AddDeliveryBoysPage()),
    Menu(name: 'Delivery Boys', child: const DeliveryBoysPage()),

    //  Menu(name: 'Subscriptions', child: const SubscriptionsPage()),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                child: Column(
                  children: menus
                      .map((e) => ListTile(
                            title: Text(e.name),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => e.child));
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
            const Divider(height: 0.5),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await ref.read(authProvider).signOut();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
