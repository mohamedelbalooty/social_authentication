import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:social_auth/model/post.dart';

class PaginationController {
  Future<List<Post>> fetchPosts({int page = 1}) async {
    Uri url = Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=10&_page=$page');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Post> data = jsonData.map((e) => Post.fromJson(e)).toList();
      return data;
    } else {
      throw Exception('error');
    }
  }
}
