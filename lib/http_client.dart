import 'package:dio/dio.dart';

Dio createHttpClinet() {
  return Dio(BaseOptions(baseUrl: "https://hacker-news.firebaseio.com/v0"));
}
