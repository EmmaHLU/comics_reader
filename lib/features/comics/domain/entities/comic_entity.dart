import 'package:equatable/equatable.dart';

// Domain entity representing a commic in the application. commic
class Comic extends Equatable{
  final int num;
  final String img;
  final String? localImage;
  final String? safeTitle;
  final String? transcript;
  final String? alt;
  final String? title;
  final String? news;
  final String? day;
  final String? month;
  final String? year;
  final String? link;
  final String? explanation;
  final bool? isFavorite;

  const Comic({
    this.localImage,
    this.month,
    this.link,
    this.year,
    this.news,
    this.safeTitle,
    this.transcript,
    this.alt,
    this.title,
    this.day,
    this.isFavorite,
    this.explanation,
    required this.num,
    required this.img
  });


  @override
  List<Object?> get props => [
    safeTitle,
    num,
    transcript,
    alt,
    title,
    day,
    month,
    year,
    explanation,
    img,
    link,
    news,
    localImage,
    isFavorite,
  ];
  
  @override
  String toString() {
    return 'Comics(title: $safeTitle, number: $num)';
  }
}