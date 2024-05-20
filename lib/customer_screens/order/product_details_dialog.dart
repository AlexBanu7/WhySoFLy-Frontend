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

  late bool soldByWeight = widget.product.soldByWeight;
  // TODO: get from api
  final String productDescription = "Probably rotten";

  List<Widget> _list_nutritional_values() {
    // TODO: individually fetch product to return its nutritional values
    Map<String, String> nutritionalValuesFromAPI = {
      "Energy": '106 KJ',
      "Total Fats": "13 g",
      "Saturated Fats": "8 g",
      "Trans Fats": "0 g",
      "Total Carbohydrates": "33 g",
      "Fibers": "6 g",
      "Sugars": "12.1 g",
      "Protein": "12 g"
    };
    List<Widget> nutritionalValues = [];
    nutritionalValuesFromAPI.forEach((key, value) {
      nutritionalValues.add(
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
                value,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        )
      );
    });
    return nutritionalValues;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(15),
      title: Text(
        "${widget.product.name}",
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child:ListView(
            children: [
              Image.asset(
                widget.product.image,
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
                    '${widget.product.pricePerQuantity} RON/${soldByWeight ? 'kg' : 'item'}',
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
                    '${widget.product.volumePerQuantity} L/${soldByWeight ? 'kg' : 'item'}',
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
                productDescription,
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
      ),
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

