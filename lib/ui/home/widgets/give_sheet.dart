import '../../../core/models/product.dart';
import '../../../core/providers/form_key_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GiveSheet extends ConsumerWidget {
  const GiveSheet({Key? key, required this.initial, required this.product})
      : super(key: key);

  final Product product;
  final int initial;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final _formKey = ref.watch(formKeyProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      height: 28,
                      width: 28,
                      child: Image.network(product.image),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      product.name,
                      style: style.subtitle2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "$initial",
                        style: style.headline6,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Icon(Icons.add),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      validator: (v)=>v!.isEmpty?"Enter quantity":(int.tryParse(v)==null?"Enter valid quantity":null),
                      onSaved: (v){
                         Navigator.pop(context,int.parse(v!));
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                  }
                },
                child: const Text('ADD'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
