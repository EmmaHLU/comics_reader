

import 'package:dartz/dartz.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/core/utils/typedefs.dart';
import 'package:learning_assistant/features/comics/domain/repositories/comic_repository.dart';


//the usecase to get the notifactions
class GetNotifactions implements UseCase<String, NoParams> {
  final ComicRepository repository;

  GetNotifactions(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await repository.getComicNotification();
  }
}