


import 'package:dartz/dartz.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/core/utils/typedefs.dart';
import 'package:learning_assistant/features/comics/domain/repositories/comic_repository.dart';


//the usecase to check comic details
class GetDetails implements UseCase<JSON, int> {
  final ComicRepository repository;

  GetDetails(this.repository);

  @override
  Future<Either<Failure, JSON>> call(int params) async {
    return await repository.getComicDetails(comicNum: params);
  }
}