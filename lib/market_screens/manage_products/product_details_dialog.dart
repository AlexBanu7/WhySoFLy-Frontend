import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/product.dart';

class ProductDetailsDialog extends StatefulWidget {

  final Product product;

  const ProductDetailsDialog({super.key, required this.product});

  @override
  _ProductDetailsDialog createState() => _ProductDetailsDialog();
}

class _ProductDetailsDialog extends State<ProductDetailsDialog>
    with SingleTickerProviderStateMixin{

  Product? product;
  Map<String, num> nutritionalValues = {};

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  Future<void> getProduct() async {
    var response = await session_requests.get(
        '/api/Product/${widget.product.id}'
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var body = json.decode(response.body);
      var nutritionalValuesFromBody = body["nutritionalValues"];
      Map<String, num> fetchedNutritionalValues = {
        "Energy": nutritionalValuesFromBody['energy'],
        "Total Fats": nutritionalValuesFromBody['totalFats'],
        "Saturated Fats": nutritionalValuesFromBody['saturatedFats'],
        "Trans Fats": nutritionalValuesFromBody['transFats'],
        "Total Carbohydrates": nutritionalValuesFromBody['totalCarbohydrates'],
        "Fibers": nutritionalValuesFromBody['fibers'],
        "Sugars": nutritionalValuesFromBody['sugars'],
        "Proteins": nutritionalValuesFromBody['proteins']
      };
      Product fetchedProduct = Product(
        id: body['id'],
        name: body['name'],
        description: body['description'],
        marketId: widget.product.marketId,
        categoryId: widget.product.categoryId,
        soldByWeight: body['soldByWeight'],
        volumePerQuantity: double.tryParse(body['volumePerQuantity'].toString())??0.0,
        pricePerQuantity: double.tryParse(body['pricePerQuantity'].toString())?? 0.0,
        image: body['image'],
        nutritionalValues: fetchedNutritionalValues
      );
      setState(() {
        product = fetchedProduct;
        nutritionalValues = fetchedNutritionalValues;
      });
    } else {
      const snackBar = SnackBar(
        content: Text('Something went wrong! Please refresh the page'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        product = null;
        nutritionalValues = {};
      });
    }
  }

  List<Widget> _list_nutritional_values() {
    List<Widget> nutritionalValuesWidgets = [];
    nutritionalValues.forEach((key, value) {
      nutritionalValuesWidgets.add(
        Padding(
          padding: const EdgeInsets.only(left:10, right:10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                key,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                value.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        )
      );
    });
    return nutritionalValuesWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(15),
      title: Row(
        children: [
          Expanded(
            child: Text(
              "${product?.name}",
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            right: 0.0,
            top: 0.0,
            child: IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.red,
              iconSize: 30,
              onPressed: () {
                nav.refreshAndPushNamed(context, ['/manage_products']);
                Navigator.pushNamed(
                  context,
                  '/edit-product',
                  arguments: product,
                );
              },
            ),
          ),
        ]
      ),
      content: product != null ?
        Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child:ListView(
              children: [
                product?.image != null ?
                    Image.memory(
                      base64Decode(product!.image!.split(',').last),
                      height: MediaQuery.of(context).size.height * 0.3,
                    ) :
                Image.asset(
                  'assets/images/question-man.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      '${product?.pricePerQuantity} RON/${product!.soldByWeight ? 'kg' : 'item'}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Volume',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      '${product?.volumePerQuantity} L/${product!.soldByWeight ? 'kg' : 'item'}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const Text(
                  'Description:',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  "${product?.description}",
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  'Nutritional Values per 100g',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
                ..._list_nutritional_values()
              ],
            ),
          ),
        ) : const Center(child: CircularProgressIndicator()),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}

