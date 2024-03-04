import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _recuperarPreco() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("Conexão None");
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.active:
            return Text("Conexão Active");
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Erro: ${snapshot.error}");
            } else {
              // Aqui você pode retornar o widget que deseja baseado no resultado do Future
              return Text("Valor: ${snapshot.data}");
            }
        }
      },
    );
  }
}
