//interface for the usecase to check comic details
import 'package:dartz/dartz.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/domain/repositories/comic_repository.dart';

///use case to get the list of comics
class GetComicList implements UseCase<List<Comic>, NoParams> {
  final ComicRepository repository;

  GetComicList(this.repository);

  @override
  Future<Either<Failure, List<Comic>>> call(NoParams params) async {
    return await repository.getComicList();
  }
}