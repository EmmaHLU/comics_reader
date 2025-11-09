//interface for the usecase to check comic details
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/features/comics/domain/repositories/comic_repository.dart';

//use case to get the explanation
class GetExplanation implements UseCase<String, ExplainParams> {
  final ComicRepository repository;

  GetExplanation(this.repository);

  @override
  Future<Either<Failure, String>> call(ExplainParams params) async {
    return await repository.getComicExplanation(comicNum: params.comicNum, title: params.title);
  }
}

class ExplainParams extends Equatable{

  final int comicNum;
  final String title;

  const ExplainParams({
    required this.comicNum,
    required this.title,
  });

  @override
  List<Object?> get props => [comicNum, title];  

}