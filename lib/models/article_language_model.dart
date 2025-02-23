import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 3)
class ArticleLanguageModel {
  @HiveField(0)
  final String en;

  @HiveField(1)
  final String? nus;

  @HiveField(2)
  final String? din;

  ArticleLanguageModel({
    required this.en,
    this.nus,
    this.din,
  });

  factory ArticleLanguageModel.fromJson(Map<String, dynamic> json) {
    return ArticleLanguageModel(
      en: json['en'],
      nus: json['nus'],
      din: json['din'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'en': en,
      'nus': nus,
      'din': din,
    };
  }
}
