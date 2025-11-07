//interface for the usecase to check comic details
import 'package:dartz/dartz.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/domain/repositories/comic_repository.dart';

//use case to get the explanation
class SearchComicNum implements UseCase<Comic, int> {
  final ComicRepository repository;

  SearchComicNum(this.repository);

  @override
  Future<Either<Failure, Comic>> call(int params) async {
    return await repository.searchComicbyNum(comicNum: params);
  }
}

//use case to get the explanation
class SearchComicText implements UseCase<Comic, String> {
  final ComicRepository repository;

  SearchComicText(this.repository);

  @override
  Future<Either<Failure, Comic>> call(String params) async {
    return await repository.searchComicbyText(text: params);
  }
}