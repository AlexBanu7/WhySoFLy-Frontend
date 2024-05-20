import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/category.dart';


class AddProductsTab extends StatefulWidget {
  const AddProductsTab({super.key});

  @override
  State<AddProductsTab> createState() => _AddProductsTab();
}

class _AddProductsTab extends State<AddProductsTab>
    with SingleTickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();

  // Fields
  String name = '';
  String? selectedCategory;
  String? soldBy;
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
                                  items: tempInits.categories.map((Category category) {
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