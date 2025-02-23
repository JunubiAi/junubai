import 'package:buai/models/article_language_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class NewsArticleModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String newsId;

  @HiveField(2)
  final ArticleLanguageModel title;

  @HiveField(3)
  final String author;

  @HiveField(4)
  final String url;

  @HiveField(5)
  final String imageUrl;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final ArticleLanguageModel content;

  @HiveField(8)
  final String publishedAt;

  @HiveField(9)
  final String? category;

  @HiveField(10)
  final String source;

  NewsArticleModel({
    required this.id,
    required this.newsId,
    required this.title,
    required this.author,
    required this.url,
    required this.imageUrl,
    required this.description,
    required this.content,
    required this.publishedAt,
    this.category,
    required this.source,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      id: json['id'],
      newsId: json['news_id'],
      title: ArticleLanguageModel.fromJson(json['title']),
      author: json['author'],
      url: json['url'],
      imageUrl: json['image_url'],
      description: json['description'],
      content: ArticleLanguageModel.fromJson(json['content']),
      publishedAt: json['published_at'],
      category: json['category'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'news_id': newsId,
      'title': title.toJson(),
      'author': author,
      'url': url,
      'image_url': imageUrl,
      'description': description,
      'content': content.toJson(),
      'published_at': publishedAt,
      'category': category,
      'source': source,
    };
  }

  factory NewsArticleModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data()!;
    return NewsArticleModel(
      id: data['id'],
      newsId: data['news_id'],
      title: ArticleLanguageModel.fromJson(data['title']),
      author: data['author'],
      url: data['url'],
      imageUrl: data['image_url'],
      description: data['description'],
      content: ArticleLanguageModel.fromJson(data['content']),
      publishedAt: data['published_at'],
      category: data['category'],
      source: data['source'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'id': id,
      'news_id': newsId,
      'title': title.toJson(),
      'author': author,
      'url': url,
      'image_url': imageUrl,
      'description': description,
      'content': content.toJson(),
      'published_at': publishedAt,
      'category': category,
      'source': source,
    };
  }
}
