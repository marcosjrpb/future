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

  _post() async {
    Post post = Post(120, null, "Titulo", "Corpo da Postagem");
    var corpo = jsonEncode(
      post.toJson(),
    );
    http.Response response = await http.post(
      Uri.parse(url + "/posts"),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: corpo,
    );
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  }

  _put() async {
    Post post = Post(120, null, "Titulo", "Corpo da Postagem");
    var corpo = jsonEncode(
      post.toJson(),
    );
    http.Response response = await http.patch(
      Uri.parse(url + "/posts/2"),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: corpo,
    );
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  }

  _patch() async {
    Post post = Post(120, null, "Titulo", "Corpo da Postagem");
    var corpo = jsonEncode(
      post.toJson(),
    );
    http.Response response = await http.put(
      Uri.parse(url + "/posts/2"),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: corpo,
    );
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  }

  _delete() async {
    http.Response response = await http.delete(
      Uri.parse(url + "/posts/2"),
    );
    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Consumo de API",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _post,
                  child: Text("Post"),
                ),
                ElevatedButton(
                  onPressed: _put,
                  child: Text("Put"),
                ),
                ElevatedButton(
                  onPressed: _patch,
                  child: Text("Patch"),
                ),
                ElevatedButton(
                  onPressed: _delete,
                  child: Text("Delete"),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
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
                                title: Text(posts[index].title ?? ""),
                                subtitle: Text(posts[index].body ?? ""),
                              );
                            },
                          );
                        } else {
                          return Center(
                              child: Text("Nenhuma postagem encontrada"));
                        }
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
