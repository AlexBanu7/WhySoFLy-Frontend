import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/models/user.dart';

class AddToCartDialog extends StatefulWidget {

  final Product product;

  const AddToCartDialog({super.key, required this.product});

  @override
  _AddToCartDialog createState() => _AddToCartDialog();
}

class _AddToCartDialog extends State<AddToCartDialog>
    with SingleTickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  num selectedQuantity = 0;
  late bool soldByWeight = widget.product.soldByWeight == 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Add ${widget.product.name} to Cart",
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Enter number of ${soldByWeight ? "kilograms" : "items"}',
              ),
              onChanged: (value) {
                setState(() {
                  if (soldByWeight) {
                    selectedQuantity = double.tryParse(value) ?? 0.0;
                  } else {
                    selectedQuantity = int.tryParse(value) ?? 0;
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number';
                }
                if (soldByWeight) {
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                } else {
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Estimated cost: ${(selectedQuantity*widget.product.pricePerQuantity).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Estimated volume: ${(selectedQuantity*widget.product.volumePerQuantity).toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  cartService.addToCart(widget.product, selectedQuantity);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product has been successfully added!')),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        )
      )
    );
  }
}

