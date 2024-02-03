import 'package:get/get.dart';
import 'package:hacker_news/http_client.dart';
import 'package:hacker_news/news_service.dart';

void configureDeps() {
  final httpClient = createHttpClinet();
  Get.put<NewsService>(NewsService(httpClient));
}
