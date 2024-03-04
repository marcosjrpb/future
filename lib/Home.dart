import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Post.dart';

class Home extends StatelessWidget {
  String url = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(Uri.parse(url + "/posts"));
    var dadosJson = json.decode(response.body);
    List<Post> postagens = List<Post>.generate(
      dadosJson.length,
      (index) => Post(
        dadosJson[index]["userId"],
        dadosJson[index]["id"],
        dadosJson[index]["title"],
        dadosJson[index]["body"],
      ),
    );
    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de API"),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("Conexão None");
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro: ${snapshot.error}");
              } else {
                List<Post>? posts = snapshot.data;
                if (posts != null && posts.isNotEmpty) {
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(posts[index].title),
                        subtitle: Text(posts[index].body),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("Nenhuma postagem encontrada"));
                }
              }
          }
        },
      ),
    );
  }
}
