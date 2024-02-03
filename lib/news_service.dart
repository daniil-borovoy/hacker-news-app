import 'package:dio/dio.dart';
import 'package:hacker_news/models.dart';

class NewsService {
  final Dio _httpClient;

  const NewsService(this._httpClient);

  static final Map<int, News> cache = {};

  Future<List<int>> fetchNewStoriesIds() async {
    final res = await _httpClient.get("/newstories.json");
    return (res.data as List).map((e) => e as int).toList();
  }

  Future<News> fetchNews(int newsId) async {
    if (cache.containsKey(newsId)) {
      return cache[newsId]!;
    }
    final res = await _httpClient.get("/item/$newsId.json");
    final news = News.fromJson(res.data);
    cache.putIfAbsent(news.id, () => news);
    return news;
  }
}
