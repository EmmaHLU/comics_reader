//interface for the usecase to check comic details
import 'package:dartz/dartz.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/features/comics/domain/repositories/comic_repository.dart';

//use case to get the explanation
class ShareComic implements UseCase<String, int> {
  final ComicRepository repository;

  ShareComic(this.repository);

  @override
  Future<Either<Failure, String>> call(int params) async {
    return await repository.shareComic(comicNum: params);
  }
}
