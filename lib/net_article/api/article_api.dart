
import 'package:dio/dio.dart';

import '../model/article.dart';

class ArticleApi{

  static const String kBaseUrl = 'https://www.wanandroid.com';
  // static const String kBaseUrl = 'http://localhost:3000';
  final Dio _client = Dio(BaseOptions(baseUrl: kBaseUrl));

  Future<List<Article>> loadArticles(int page) async {
    String path = '/article/list/$page/json';
    // String path = '/articles';
    var rep = await _client.get(path);
    if (rep.statusCode == 200) {
      if(rep.data!=null){
        var data = rep.data['data']['datas'] as List;
        print(data);
        return data.map(Article.formMap).toList();
      }
    }
    return [];
  }
}