
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';


class Session {
  Map<String, String> headers = {"Content-Type": "application/json"};

  static String ip = '<your_ipv4_here>:5229';
  static String base_url = 'http://' + ip;
  static String ws_url = 'ws://' + ip + '/ws';

  WebSocketChannel? channel;
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<http.Response> get(String path) async {
    http.Response response = await http.get(Uri.parse(base_url+path), headers: headers);
    updateCookie(response);
    return response;
  }

  Future<http.Response> post(String path, dynamic data) async {
    http.Response response = await http.post(Uri.parse(base_url+path), body: data, headers: headers);
    updateCookie(response);
    return response;
  }

  Future<http.Response> put(String path, dynamic data) async {
    http.Response response = await http.put(Uri.parse(base_url+path), body: data, headers: headers);
    updateCookie(response);
    return response;
  }

  Future<http.Response> patch(String path, dynamic data) async {
    http.Response response = await http.patch(Uri.parse(base_url+path), body: data, headers: headers);
    updateCookie(response);
    return response;
  }

  Future<http.Response> delete(String path) async {
    http.Response response = await http.delete(Uri.parse(base_url+path), headers: headers);
    updateCookie(response);
    return response;
  }

  void setUpChannel(String redirectOnReceive) {
    WebSocketChannel _channel = WebSocketChannel.connect(
      Uri.parse(ws_url),
    );
    channel = _channel;
    _channel.stream.listen((message) async {
      print('Received message: $message');
      final snackBar = SnackBar(
        content: Text(message.toString()),
        duration: const Duration(days: 1), // Set a long duration
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      nav.refreshAndPushNamed(_context!, [redirectOnReceive]);
      ScaffoldMessenger.of(_context!).showSnackBar(snackBar);

    });
    _channel.sink.add(currentUser?.email??"");
  }

  void sendMessage(String message, {BuildContext? context}) {
    _context = context;
    print("Sending message: $message");
    channel?.sink.add(json.encode({
        "command": message
    }));
  }

  void closeChannel() {
    print("Closing socket");
    channel?.sink.close();
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}