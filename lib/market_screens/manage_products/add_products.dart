import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/category.dart';
import 'package:frontend/widgets/image_input.dart';


class AddProductsTab extends StatefulWidget {
  const AddProductsTab({super.key});

  @override
  State<AddProductsTab> createState() => _AddProductsTab();
}

class _AddProductsTab extends State<AddProductsTab>
    with SingleTickerProviderStateMixin{

  List<Category> categories = [];
  final _formKey = GlobalKey<FormState>();

  // Fields
  File? image;
  String name = '';
  String? selectedCategory;
  String? soldBy;
  num? pricePerQuantity;
  num? volumePerQuantity;
  final List<String> _items = ['Item', 'Kilograms'];
  String description = '';
  Map<String, num?> nutritionalValues = {
    "Energy (KJ)": null,
    "Total Fats (g)": null,
    "Saturated Fats (g)": null,
    "Trans Fats (g)": null,
    "Total Carbohydrates (g)": null,
    "Fibers (g)": null,
    "Sugars (g)": null,
    "Protein (g)": null,
  };

  String _error = '';
  bool _loading = false; // Track loading state

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCategories().then((value) {
      setState(() {
        categories = value;
        _loading = false;
      });
    });
  }

  void passImage(File passedImage) {
    setState(() {
      image = passedImage;
    });
  }

  Future<List<Category>> getCategories() async {
    var response = await session_requests.get(
        '/api/Category'
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Category> categories = [];
      var body = json.decode(response.body);
      for (var category in body) {
        Category newCategory = Category(
            id: category['id'],
            name: category['name'],
            products: []
        );
        categories.add(newCategory);
      }
      return categories;
    } else {
      const snackBar = SnackBar(
        content: Text('Something went wrong! Please refresh the page'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return [];
    }
  }

  List<Widget> _nutritional_values_fields() {
    List<Widget> nutritional_values_fields = [];
    nutritionalValues.forEach((key, value) {
      nutritional_values_fields.addAll([
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: key,
          ),
          onChanged: (value) {
            setState(() {
              nutritionalValues[key] = num.tryParse(value);
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20)
      ]);
    });
    return nutritional_values_fields;
  }

  void onConfirm() {
    setState(() {
      _loading = false; // Start loading
      _error = ''; // Clear previous error
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true; // Start loading
        _error = ''; // Clear previous error
      });
      // get category id by the selected name
      num selectedCategoryId = categories.firstWhere((element) => element.name == selectedCategory).id;
      Map<String, num?> formatterNutritionalValues = {
        "energy": nutritionalValues["Energy (KJ)"] ?? 0,
        "totalFats": nutritionalValues["Total Fats (g)"] ?? 0,
        "saturatedFats": nutritionalValues["Saturated Fats (g)"] ?? 0,
        "transFats": nutritionalValues["Trans Fats (g)"] ?? 0,
        "totalCarbohydrates": nutritionalValues["Total Carbohydrates (g)"] ?? 0,
        "fibers": nutritionalValues["Fibers (g)"] ?? 0,
        "sugars": nutritionalValues["Sugars (g)"] ?? 0,
        "proteins": nutritionalValues["Protein (g)"] ?? 0,
      };
      var data = {
        'name': name,
        'description': description,
        'categoryId': selectedCategoryId,
        "pricePerQuantity": pricePerQuantity,
        "volumePerQuantity": volumePerQuantity,
        'soldByWeight': soldBy == _items[1] ? true : false,
        'image': image != null ? base64Encode(image!.readAsBytesSync()) : null,
        "marketId": currentUser?.market?.id,
        'nutritionalValues': formatterNutritionalValues,
      };
      session_requests.post(
        '/api/Product',
        json.encode(data),
      ).then((response) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          setState(() {
            _loading = false;
          });
          const snackBar = SnackBar(
            content: Text('Product has been successfully added!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          setState(() {
            _error = 'Something went wrong. Please try again.';
            _loading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/cloud-bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Fill out your Product's details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width - 100,
                      child: ShaderMask(
                        shaderCallback: (Rect rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                            stops: [0.0, 0.0, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstOut,
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ImageInput(passImage: passImage),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter name of you product.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: selectedCategory,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCategory = newValue;
                                    });
                                  },
                                  items: categories.map((Category category) {
                                    return DropdownMenuItem<String>(
                                      value: category.name,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select an item';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Select the Quantity Measurement',
                                    border: OutlineInputBorder(),
                                  ),
                                  value: soldBy,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      soldBy = newValue;
                                    });
                                  },
                                  items: _items.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select an item';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  maxLines: null,  // Allows the TextField to expand vertically
                                  keyboardType: TextInputType.multiline,
                                  decoration: const InputDecoration(
                                    labelText: "Description",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the description ("-" if none)';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      description = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: "Volume per Quantity Unit",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      volumePerQuantity = num.tryParse(value);
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: "Price per Quantity Unit",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      pricePerQuantity = num.tryParse(value);
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Nutritional Values per 100g",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                ..._nutritional_values_fields(),
                                SizedBox(height: 20),
                                _loading
                                    ? const CircularProgressIndicator() // Show circular progress indicator if loading
                                    : ElevatedButton(
                                      onPressed: _submitForm,
                                      child: const Text('Add Product'),
                                    ),
                                const SizedBox(height: 10),
                                Text(
                                  _error,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                // Add keyboard height sized box
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}