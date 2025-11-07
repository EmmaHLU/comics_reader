//interface for the usecase to check comic details
import 'package:dartz/dartz.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/features/comics/domain/repositories/comic_repository.dart';

class GetExplanation implements UseCase<String, int> {
  final ComicRepository repository;

  GetExplanation(this.repository);

  @override
  Future<Either<Failure, String>> call(int params) async {
    return await repository.getComicExplanation(comicNum: params);
  }
}