class News {
  final int id, score, descendants;
  final String by, title, type;
  final String? url;
  final DateTime time;

  const News({
    required this.id,
    required this.descendants,
    required this.score,
    required this.title,
    required this.time,
    required this.type,
    required this.url,
    required this.by,
  });

  factory News.fromJson(Map json) {
    return News(
      id: json['id'],
      by: json['by'],
      descendants: json['descendants'],
      score: json['score'],
      time: DateTime.fromMillisecondsSinceEpoch(json['time'] * 1000),
      title: json['title'],
      type: json['type'],
      url: json['url'],
    );
  }
}
