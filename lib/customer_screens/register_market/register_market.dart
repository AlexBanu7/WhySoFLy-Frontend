import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/register_market/market_confirmation_dialog.dart';
import 'package:frontend/customer_screens/register_market/market_location_dialog.dart';
import 'package:frontend/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class RegisterMarketPage extends StatefulWidget {
  const RegisterMarketPage({super.key});

  @override
  State<RegisterMarketPage> createState() => _RegisterMarketPage();
}

class _RegisterMarketPage extends State<RegisterMarketPage>
    with SingleTickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  Map<String, TimeOfDay?> marketHours = {
    "_weekdaysOpeningTime": null,
    "_weekdaysClosingTime": null,
    "_weekendOpeningTime": null,
    "_weekendClosingTime": null,
  };
  LatLng? location;
  String name = '';
  String _error = '';
  bool _loading = false; // Track loading state

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onConfirm() async {
    Map<String, String> data = {
      "email": currentUser?.email ?? "",
      "name": name,
      "latitude": location?.latitude.toString() ?? "",
      "longitude": location?.longitude.toString() ?? "",
      "workDay": "${marketHours['_weekdaysOpeningTime']!.format(context)} - ${marketHours['_weekdaysClosingTime']!.format(context)}",
      "weekend": "${marketHours['_weekendOpeningTime']!.format(context)} - ${marketHours['_weekendClosingTime']!.format(context)}",
    };
    var response = await session_requests.post(
      '/api/Market',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Parse the JSON response body into a Dart object
      const snackBar = SnackBar(
        content: Text('Market Registered! An admin will review your request.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        _loading = false; // Stop loading
        _error = ''; // Clear previous error
      });
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true; // Start loading
        _error = ''; // Clear previous error
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MarketConfirmationDialog(onConfirm: onConfirm);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    session_requests.setContext(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar("Let's set up shop!"),
        drawer: const CustomDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/cloud-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width, // full width
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    'assets/images/market.png', // Path to your image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0), // Adjust as needed
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Fill out your Market's details",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter name of you business.';
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
                                const Text(
                                  "Weekend Hours",
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (marketHours['_weekendOpeningTime'] == null) {
                                            return 'This field must be picked';
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        onTap: () {
                                          _selectTime(context, '_weekendOpeningTime');
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Opening Hours',
                                        ),
                                        controller: TextEditingController(
                                            text: marketHours['_weekendOpeningTime'] != null
                                                ? '${marketHours['_weekendOpeningTime']?.hour}:${marketHours['_weekendOpeningTime']?.minute}'
                                                : ''),
                                      ),
                                    ),
                                    SizedBox(width: 40.0),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (marketHours['_weekendClosingTime'] == null) {
                                            return 'This field must be picked';
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        onTap: () {
                                          _selectTime(context, '_weekendClosingTime');
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Closing Hours',
                                        ),
                                        controller: TextEditingController(
                                            text: marketHours['_weekendClosingTime'] != null
                                                ? '${marketHours['_weekendClosingTime']?.hour}:${marketHours['_weekendClosingTime']?.minute}'
                                                : ''),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Weekdays Hours",
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (marketHours['_weekdaysOpeningTime'] == null) {
                                            return 'This field must be picked';
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        onTap: () {
                                          _selectTime(context, '_weekdaysOpeningTime');
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Opening Hours',
                                        ),
                                        controller: TextEditingController(
                                            text: marketHours['_weekdaysOpeningTime'] != null
                                                ? '${marketHours['_weekdaysOpeningTime']?.hour}:${marketHours['_weekdaysOpeningTime']?.minute}'
                                                : ''),
                                      ),
                                    ),
                                    SizedBox(width: 40.0),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (marketHours['_weekdaysClosingTime'] == null) {
                                            return 'This field must be picked';
                                          }
                                          return null;
                                        },
                                        readOnly: true,
                                        onTap: () {
                                          _selectTime(context, '_weekdaysClosingTime');
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Closing Hours',
                                        ),
                                        controller: TextEditingController(
                                            text: marketHours['_weekdaysClosingTime'] != null
                                                ? '${marketHours['_weekdaysClosingTime']?.hour}:${marketHours['_weekdaysClosingTime']?.minute}'
                                                : ''),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  validator: (value) {
                                    if (location == null) {
                                      return 'Please enter the location';
                                    }
                                    return null;
                                  },
                                  readOnly: true,
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => MarketLocationDialog(onConfirm: onSelectLocation)
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Location',
                                    suffixIcon: Icon(Icons.location_on),
                                  ),
                                  controller: TextEditingController(
                                      text: location != null ? location.toString() : ''),
                                ),
                                const SizedBox(height: 20),
                                _loading
                                    ? const CircularProgressIndicator() // Show circular progress indicator if loading
                                    : ElevatedButton(
                                      onPressed: _submitForm,
                                      child: const Text('Send Request'),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> _selectTime(BuildContext context, String hourKey) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: marketHours[hourKey] ?? TimeOfDay.now(),
    );
    if (picked != null && picked != marketHours[hourKey]) {
      setState(() {
        marketHours[hourKey] = picked;
      });
    }
  }

  void onSelectLocation(LatLng? selectedLocation) {
    if (selectedLocation != null){
      setState(() {
        location = selectedLocation;
      });
    }
  }
}