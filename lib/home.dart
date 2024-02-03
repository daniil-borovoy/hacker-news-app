import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacker_news/models.dart';
import 'package:hacker_news/news_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: NewsList(),
    );
  }
}

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<StatefulWidget> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final NewsService _newsService = Get.find();

  late Future<List<int>> _fetchTopStoriesFuture;

  @override
  void initState() {
    super.initState();
    _fetchTopStoriesFuture = _newsService.fetchNewStoriesIds();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchTopStoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator());
        }
        return CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Hacker News',
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                _fetchTopStoriesFuture = _newsService.fetchNewStoriesIds();
                await _fetchTopStoriesFuture;
                setState(() {});
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(children: [
                        NewsCard(newsId: snapshot.data![index]),
                        Divider(
                          color: Colors.grey[300],
                          indent: 10,
                          endIndent: 10,
                        )
                      ]),
                    );
                  }
                  return Column(children: [
                    NewsCard(newsId: snapshot.data![index]),
                    Divider(
                      color: Colors.grey[300],
                      indent: 10,
                      endIndent: 10,
                    )
                  ]);
                },
                childCount: snapshot.data!.length,
              ),
            ),
          ],
        );
      },
    );
  }
}

class NewsCard extends StatefulWidget {
  final int newsId;

  const NewsCard({super.key, required this.newsId});

  @override
  State<StatefulWidget> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  get newsId => widget.newsId;
  final NewsService _newsService = Get.find();

  late Future<News> _future;

  @override
  void initState() {
    _future = _newsService.fetchNews(newsId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
              child: Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CupertinoActivityIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return CupertinoButton(
              onPressed: () {
                setState(() {
                  _future = _newsService.fetchNews(newsId);
                });
              },
              child: const Center(
                child: Text(
                  'Error while fetching... Tap to reload',
                  style: TextStyle(fontSize: 14, color: Colors.red),
                ),
              ),
            );
          }
          final url = snapshot.data?.url;
          final date =
              snapshot.data?.time.toLocal() ?? DateTime.now().toLocal();
          return CupertinoButton(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.zero,
            onPressed: url != null
                ? () async {
                    final uri = Uri.parse(url);
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.inAppWebView,
                      webViewConfiguration: const WebViewConfiguration(
                        enableJavaScript: true,
                        enableDomStorage: true,
                      ),
                    )) {
                      throw Exception('Could not launch $url');
                    }
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.title,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat('dd MMMM yyyy – kk:mm').format(date),
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black45),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(CupertinoIcons.link, size: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
