import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchField extends HookWidget {
  const SearchField({ Key? key, required this.onChanged }) : super(key: key);
  
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration:  InputDecoration(
         prefixIcon: const Icon(Icons.search),
         hintText: 'Search by Name, Phone number, Address',
         suffixIcon: CloseButton(
           onPressed: (){
             controller.clear();
             onChanged('');
           },
         )
      ),
      
    );
  }
}