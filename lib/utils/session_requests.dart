
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';


class Session {
  Map<String, String> headers = {"Content-Type": "application/json"};

  static String ip = '192.168.1.110:5229';
  static String base_url = 'http://' + ip;
  static String ws_url = 'ws://' + ip + '/ws';

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

  Future<http.Response> delete(String path) async {
    http.Response response = await http.delete(Uri.parse(base_url+path), headers: headers);
    updateCookie(response);
    return response;
  }

  WebSocketChannel setUpChannel() {
    WebSocketChannel _channel = WebSocketChannel.connect(
      Uri.parse(ws_url),
    );
    return _channel;
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