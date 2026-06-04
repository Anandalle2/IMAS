import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const baseUrl =
      "http://3.110.181.83:8000";

  static Future get(
      String endpoint) async {

    final response =
    await http.get(
      Uri.parse(
          "$baseUrl$endpoint"),
    );

    return jsonDecode(
        response.body);
  }

  static Future post(

      String endpoint,

      Map body

      ) async {

    final response =
    await http.post(

      Uri.parse(
          "$baseUrl$endpoint"),

      headers:{

        "Content-Type":
        "application/json"
      },

      body:
      jsonEncode(body),
    );

    return jsonDecode(
        response.body);
  }

  static Future delete(
      String endpoint) async {

    final response =
    await http.delete(
      Uri.parse(
          "$baseUrl$endpoint"),
    );

    return jsonDecode(
        response.body);
  }
}