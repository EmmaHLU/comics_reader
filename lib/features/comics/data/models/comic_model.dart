import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';

class ComicModel extends Comic{

  const ComicModel({
    super.month,
    super.link,
    super.year,
    super.news,
    super.safeTitle,
    super.transcript,
    super.alt,
    super.title,
    super.day,
    super.explanation,
    required super.num,
    required super.img
  });

  /// Create ComicsModel from JSON
  factory ComicModel.fromJson(Map<String, dynamic> json) {
    return ComicModel(
      month: json['month'] as String?,
      num: json['num'] as int,
      link: json['link'] as String?,
      year: json['year'] as String?,
      news: json['news'] as String?,
      safeTitle: json['safe_title'] as String?,
      transcript: json['transcript'] as String?,
      alt: json['alt'] as String?,
      img: json['img'] as String, // required
      title: json['title'] as String?,
      day: json['day'] as String?,
      explanation: json['explanation'] as String?, // optional
    );
  }
  
/// Create ComicModel from domain entity
factory ComicModel.fromEntity(Comic entity) {
  return ComicModel(
    month: entity.month,
    num: entity.num,
    link: entity.link,
    year: entity.year,
    news: entity.news,
    safeTitle: entity.safeTitle,
    transcript: entity.transcript,
    alt: entity.alt,
    img: entity.img,
    title: entity.title,
    day: entity.day,
    explanation: entity.explanation,
  );
}

/// Convert to domain entity
Comic toEntity() {
  return Comic(
    month: month,
    num: this.num,
    link: link,
    year: year,
    news: news,
    safeTitle: safeTitle,
    transcript: transcript,
    alt: alt,
    img: img,
    title: title,
    day: day,
    explanation: explanation,
  );
}

}