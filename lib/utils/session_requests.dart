
import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = {"Content-Type": "application/json"};

  String base_url = 'http://192.168.5.106:5229';

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

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}