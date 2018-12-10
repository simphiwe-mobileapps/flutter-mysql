import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiCall{
  static Map data;
  static List keys;

  static Future<Map> get_data(url)async {
    
    http.Response response = await http.get(url);

    Map body = json.decode(response.body);

    data = body;
    return body;
  }

  static Future post_data(url, data) async{
    Map result;
    http.Response response = await http.post(url, body: data);

    return json.decode(response.body);
  }
}