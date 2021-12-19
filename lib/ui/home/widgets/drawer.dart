import 'package:delivery_m/ui/customers/customers_page.dart';
import 'package:delivery_m/ui/delivery_boys/add_delivery_boys_page.dart';
import 'package:delivery_m/ui/products/products_page.dart';
import 'package:delivery_m/ui/subscriptions/subscriptions_page.dart';
import 'package:flutter/material.dart';


class Menu {
  final String name;
  final Widget child;

  Menu({required this.name, required this.child});
}

class MyDrawer extends StatelessWidget {
   MyDrawer({ Key? key }) : super(key: key);
   List<Menu> menus = [
     Menu(name: 'Add Delivery Boys', child: AddDeliveryBoysPage()),
     Menu(name: 'Customers', child: CustomersPage()),
     Menu(name: 'Products', child: ProductsPage()),
     Menu(name: 'Subscriptions', child: SubscriptionsPage()),
   ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: menus.map((e) => ListTile(
            title: Text(e.name),
            onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>e.child));
            },
          )).toList(),
        ),
      ),
    );
  }
}