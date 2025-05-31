import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phones.dart';

class ApiService {
  static const String baseUrl = 'https://resp-api-three.vercel.app';

  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Phone>> fetchPhones() async {
  final response = await http.get(Uri.parse('$baseUrl/phones'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    List data = json['data']; // ✅ ambil dari key 'data'
    return data.map((e) => Phone.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load phones');
  }
}


  static Future<Phone> fetchPhoneDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/phones/$id'));
    if (response.statusCode == 200) {
      return Phone.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch phones detail');
    }
  }

  static Future<Phone> createPhone(Phone phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phone'), // endpoint disesuaikan
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(phone.toJson()),
    );
    print('==> [DEBUG POST /phone] status: ${response.statusCode}');
    print('==> [DEBUG POST /phone] body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> createdJson =
          json.decode(response.body) as Map<String, dynamic>;
      return Phone.fromJson(createdJson);
    } else {
      throw Exception('Failed to create phone (status ${response.statusCode})');
    }
  }

  static Future<Phone> updatePhone(int id, Phone phone) async {
    final response = await http.put(
      Uri.parse('$baseUrl/phone/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(phone.toJson()),
    );
    print('==> [DEBUG PUT /phone/$id] status: ${response.statusCode}');
    print('==> [DEBUG PUT /phone/$id] body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> updatedJson =
          json.decode(response.body) as Map<String, dynamic>;
      return Phone.fromJson(updatedJson);
    } else {
      throw Exception('Failed to update phone with id $id');
    }
  }

  static Future<void> deletePhone(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/phone/$id'));
    print('==> [DEBUG DELETE /phone/$id] status: ${response.statusCode}');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete phone with id $id');
    }
  }
}