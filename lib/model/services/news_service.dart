import 'dart:convert';

import 'package:sharing_map/model/data/article.dart';
import 'package:http/http.dart' as http;

class Constants {
  static const apiKey = 'd4c8d62cc70545b9b687df1845fd0d04';
  static const topHeadlines =
      'https://newsapi.org/v2/everything?q=stock&from=2023-06-09&sortBy=publishedAt&apiKey=$apiKey';
}

class NewsWebService {
  static var client = http.Client();

  static Future<List<Article>?> fetchNews() async {
    var response = await client.get(Uri.parse(Constants.topHeadlines));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return (jsonData['articles'] as List)
          .map((e) => Article.fromJson(e))
          .toList();
    } else {
      return null;
    }
  }

  static Future<List<Article>?> fetchNewsQuery(String query) async {
    const apiKey = 'd4c8d62cc70545b9b687df1845fd0d04';
    var uri =
        'https://newsapi.org/v2/everything?q=$query&from=2023-06-10&sortBy=publishedAt&apiKey=$apiKey';

    var response = await client.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return (jsonData['articles'] as List)
          .map((e) => Article.fromJson(e))
          .toList();
    } else {
      return null;
    }
  }
}
