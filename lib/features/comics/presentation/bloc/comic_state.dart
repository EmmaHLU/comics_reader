import 'package:equatable/equatable.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';

/// Base class for all authentication states
abstract class ComicState extends Equatable {

  const ComicState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ComicInitial extends ComicState {
  const ComicInitial();
}

//state when loading the comic
class ComicLoadingState extends ComicState{
  const ComicLoadingState();
}

//state when loading the comic
class ComicsLoadingState extends ComicState{
  const ComicsLoadingState();
}

//state when the comic is successfully loaded
class ComicLoadedState extends ComicState{
  final Comic comic;
  const ComicLoadedState({required this.comic});
}

//state when downloading the comic
class ComicDownLoadingState extends ComicState{
  const ComicDownLoadingState();
}

//state when comic list is loaded
class ComicsLoadedState extends ComicState {
  final List<Comic> comics;
  const ComicsLoadedState({this.comics = const []});
}

//state when saving the comic
class ComicSavingState extends ComicState{
  const ComicSavingState();
}

//state when saved the comic
class ComicFavoriateSavedState extends ComicState{
  const ComicFavoriateSavedState();
}

//state when saved the comic
class ComicFavoriateLoadingState extends ComicState{

  const ComicFavoriateLoadingState();
}
//state when saved the comic
class ComicFavoriateLoadedState extends ComicState{
  final List<Comic> comics;
  const ComicFavoriateLoadedState({required this.comics});
}
//state when saved the comic
class ComicFavoriateLFailedState extends ComicState{
  final Failure failure;
  const ComicFavoriateLFailedState({required this.failure});
}

//state when saving the comic
class ComicFailedState extends ComicState{
  final Failure failure;
  const ComicFailedState({required this.failure});
}

//state when deleting the comic
class ComicFavoriateDeletingState extends ComicState{
  const ComicFavoriateDeletingState();
}
//state when saving the comic
class ComicFavoriateDeletedState extends ComicState{
  const ComicFavoriateDeletedState();
}

//state when the explaination is fetched
class ComicExplainingState extends ComicState{
  const ComicExplainingState();
}

//state when the explaination is fetched
class ComicExplainedState extends ComicState{
  final String explaination;
  const ComicExplainedState({required this.explaination});
}

//state when the explaination is fetched
class ComicExplaineFailedState extends ComicState{
  final Failure failure;
  const ComicExplaineFailedState({required this.failure});
}
//state when deleting the comic
class ComicSharingState extends ComicState{
  const ComicSharingState();
}
//state when saving the comic
class ComicSharedState extends ComicState{
  const ComicSharedState();
}

//state when saving the comic
class ComicShareFaileddState extends ComicState{
  final Failure failure;
  const ComicShareFaileddState({required this.failure});
}

//state when a comic is not found
class ComicNotFoundState extends ComicState{
  final String message;
  const ComicNotFoundState({required this.message});
}

//state when a comic is not found
class ComicSearchingByNumState extends ComicState{
  const ComicSearchingByNumState();
}

class ComicNumSearchFoundState extends ComicState{
  final Comic comic;
  const ComicNumSearchFoundState({required this.comic});
}
class ComicNumSearchNotFoundState extends ComicState{
  final Failure failure;
  const ComicNumSearchNotFoundState({required this.failure});
}
//state when a comic is not found
class ComicSearchingByTextState extends ComicState{
  const ComicSearchingByTextState();
}

class ComicTextSearchFoundState extends ComicState{
  final Comic comic;
  const ComicTextSearchFoundState({required this.comic});
}
class ComicTextSearchNotFoundState extends ComicState{
  final Failure failure;
  const ComicTextSearchNotFoundState({required this.failure});
}

class ComicFoundState extends ComicState{
  final Comic comic;
  const ComicFoundState({required this.comic});
}

class NewComicNotiReceivedState extends ComicState{
  final String message;
  const NewComicNotiReceivedState({required this.message});
}