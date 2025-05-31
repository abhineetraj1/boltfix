import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:boltfix/main.dart';
import 'package:boltfix/variables.dart';

Future<bool> PostOrder() async {
  final storage = FlutterSecureStorage();
  try {
    var name = await storage.read(key: 'name');
    var phone = await storage.read(key: 'phone');    
    if (name == null || phone == null) return false;
    final response = await http.post(Uri.parse(url+"order"),headers: {'Content-Type': 'application/json'},body: jsonEncode({'name': name,'phone': phone,'info': info,'location':location,'service':cart}),);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

StoreData(name, phone) async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'name', value: name);
  await storage.write(key: 'phone', value: phone);
}

isDateStored() async {
  final storage = FlutterSecureStorage();
  String? name = await storage.read(key: 'name');
  String? phone = await storage.read(key: 'phone');
  if (name != null && phone != null) {
    return true;
  } else {
    return false;
  }
}