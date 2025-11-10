
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/usecase/usecase.dart';
import 'package:learning_assistant/features/comics/domain/usecases/check_details.dart';
import 'package:learning_assistant/features/comics/domain/usecases/delete_lcoal_comic.dart';
import 'package:learning_assistant/features/comics/domain/usecases/explain_comic.dart';
import 'package:learning_assistant/features/comics/domain/usecases/get_local_comic_list.dart';
import 'package:learning_assistant/features/comics/domain/usecases/get_remote_comic.dart';
import 'package:learning_assistant/features/comics/domain/usecases/get_remote_comic_list.dart';
import 'package:learning_assistant/features/comics/domain/usecases/save_comic.dart';
import 'package:learning_assistant/features/comics/domain/usecases/search_comic.dart';
import 'package:learning_assistant/features/comics/domain/usecases/share_comic.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_event.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_state.dart';

class ComicBloc extends Bloc<ComicEvent, ComicState>{
  final GetDetails getDetails;
  final GetExplanation getExplanation;
  final GetComicList getComicList;
  final GetComic getComic;
  final SaveComic saveComic;
  final SearchComicNum searchComicNum;
  final SearchComicText searchComicText;
  final ShareComic shareComic;
  final GetLocalComicList getLocalComicList;
  final DeleteLcoalComic deleteLcoalComic;

  ComicBloc({
    required this.getDetails,
    required this.getExplanation,
    required this.getComicList,
    required this.getComic,
    required this.saveComic,
    required this.searchComicNum,
    required this.searchComicText,
    required this.shareComic,
    required this.getLocalComicList,
    required this.deleteLcoalComic,
  }): super(ComicInitial()) {
    on<ComicGetRequest>(_onComicGetRequested);
    on<ComicGetListRequest>(_onComicGetListRequested);
    on<ComicSearchNumRequest>(_onComicSearchNumRequested);
    on<ComicSearchTextRequest>(_onComicSearchTextRequested);
    on<ComicSaveRequest>(_onComicSavetRequested);
    on<ComicDeleteRequest>(_onComicDeleteRequested);
    on<ComicExplainRequest>(_onComicExplainRequested);
    on<ComicShareRequest>(_onComicShareRequested);
    on<ComicLoadFavoriatesRequest>(_onComicLoadFavoriatesRequested);
    on<NewComicNotificationReceived>(_onNewComicNotificationReceived);
  }

  ///bussiness logic to handle get the comic request
  Future<void> _onComicGetRequested(
    ComicGetRequest event,
    Emitter<ComicState> emit,
  ) async {
    emit(const ComicLoadingState());

    final result = await getComic(event.num);

    result.fold(
      (failure) => emit(ComicNotFoundState(message:"Comic Not Found")),
      (comic) => emit(ComicLoadedState(comic: comic)),
    );
  }

  Future<void> _onComicGetListRequested(
    ComicGetListRequest event,
    Emitter<ComicState> emit,
  ) async {
    emit(const ComicsLoadingState());
    final result = await getComicList(NoParams());
    result.fold(
      (failure) => emit(ComicNotFoundState(message:"Comics Not Found")),
      (comics) => emit(ComicsLoadedState(comics: comics)),
    );
  }

  Future<void> _onComicSearchNumRequested(
    ComicSearchNumRequest event,
    Emitter<ComicState> emit,
  )async{
    emit(const ComicSearchingByNumState());
    final result = await searchComicNum(event.num);
    result.fold(
      (failure) => emit(ComicNotFoundState(message:"Comic ${event.num} Not Found")),
      (comic) => emit(ComicFoundState(comic: comic)),
    );
  }

   Future<void> _onComicSearchTextRequested(
    ComicSearchTextRequest event,
    Emitter<ComicState> emit,
  )async{
    emit(const ComicSearchingByNumState());
    final result = await searchComicText(event.text);
    result.fold(
      (failure) => emit(ComicNotFoundState(message:"Comic with '${event.text}' Not Found")),
      (comic) => emit(ComicFoundState(comic: comic)),
    );
  }

  Future<void> _onComicSavetRequested(
    ComicSaveRequest event,
    Emitter<ComicState> emit,
  )async{
    emit(ComicSavingState());
    final result = await saveComic(event.num);

    result.fold(
      (failure) => emit(ComicFavoriateLFailedState(failure: failure)),
      (result) => emit(ComicFavoriateSavedState()),
    );
  }

  Future<void> _onComicLoadFavoriatesRequested(
    ComicLoadFavoriatesRequest event,
    Emitter<ComicState> emit,
  )async{
    emit(ComicFavoriateLoadingState());
    final result = await getLocalComicList(NoParams());

    result.fold(
      (failure) => emit(ComicFavoriateLFailedState(failure: failure)),
      (favoriates) => emit(ComicFavoriateLoadedState(comics: favoriates)),
    );
  }
  Future<void> _onComicDeleteRequested(
    ComicDeleteRequest event,
    Emitter<ComicState> emit,
  )async{
    emit(ComicFavoriateDeletingState());
    final result = await deleteLcoalComic(event.num);

    result.fold(
      (failure) => emit(ComicFailedState(failure: failure)),
      (result) => emit(ComicFavoriateDeletedState()),
    );
  }

  Future<void> _onComicExplainRequested(
    ComicExplainRequest event,
    Emitter emit,
  )async{
    emit(ComicExplainingState());
    final result = await getExplanation(ExplainParams(comicNum: event.num, title: event.title));

    result.fold(
      (failure) => emit(ComicExplaineFailedState(failure: failure)),
      (explanation) => emit(ComicExplainedState(explaination: explanation)),
    );
  }

  Future<void> _onComicShareRequested(
    ComicShareRequest event,
    Emitter emit,
  )async{
    emit(ComicSharingState());
    final result = await shareComic(event.num);
    result.fold(
      (failure) => emit(ComicShareFaileddState(failure: failure)),
      (result) => emit(ComicSharedState()));
  }

  Future<void> _onNewComicNotificationReceived(
    NewComicNotificationReceived event,
    Emitter emit,
  )async{
    emit(NewComicNotiReceivedState(message: event.message));
  }
}