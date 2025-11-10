import 'package:equatable/equatable.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';

/// Base class for all comic events
abstract class ComicEvent extends Equatable {
  const ComicEvent();

  @override
  List<Object?> get props => [];
}

///Event to get a comic
class ComicGetRequest extends ComicEvent{
  final int num;
  const ComicGetRequest({required this.num});

  @override
  List<Object?> get props => [num];
}
///Event to get all comics for browse
class ComicGetListRequest extends ComicEvent{
  const ComicGetListRequest();
}

///Event to get all comics for browse
class ComicLoadmoreRequest extends ComicEvent{
  const ComicLoadmoreRequest();
}
///Event to search a comic by num
class ComicSearchNumRequest extends ComicEvent{
  final int num;
  const ComicSearchNumRequest({required this.num});
  @override
  List<Object?> get props => [num];
}

///Event to search a comic by text
class ComicSearchTextRequest extends ComicEvent{
  final String text;
  const ComicSearchTextRequest({required this.text});
  @override
  List<Object?> get props => [text];
}

///Save a comic
class ComicSaveRequest extends ComicEvent{
  final int num;
  const ComicSaveRequest({required this.num});
  @override
  List<Object?> get props => [num];
}

class ComicLoadFavoriateRequest extends ComicEvent{
  final int num;
  const ComicLoadFavoriateRequest({required this.num});
  @override
  List<Object?> get props => [num];
}

class ComicLoadFavoriatesRequest extends ComicEvent{
  const ComicLoadFavoriatesRequest();
}

///Delete a comic
class ComicDeleteRequest extends ComicEvent{
  final int num;
  const ComicDeleteRequest({required this.num});
  @override
  List<Object?> get props => [num];
}

///get explaination of a comic
class ComicExplainRequest extends ComicEvent{
  final int num;
  final String title;
  const ComicExplainRequest({required this.num, required this.title});

  @override
  List<Object?> get props => [num];
}

///share a comic
class ComicShareRequest extends ComicEvent{
  final int num;
  const ComicShareRequest({required this.num});

  @override
  List<Object?> get props => [num];
}

///get explaination of a comic
class NewComicNotificationReceived extends ComicEvent{
  final String message;
  const NewComicNotificationReceived({required this.message});

  @override
  List<Object?> get props => [message];
}