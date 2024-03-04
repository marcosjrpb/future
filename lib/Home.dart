import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _recuperarPreco() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(url as Uri);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<Map>(
        future: _recuperarPreco(),
        builder: builder
    ),
  }
}
