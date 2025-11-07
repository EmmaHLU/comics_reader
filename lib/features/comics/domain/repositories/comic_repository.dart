
import 'package:dartz/dartz.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/core/utils/typedefs.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';

///  interface for Comic operations 
abstract class ComicRepository {

  ///get a comic by num
  ///returns either <Failure, Comic>
  Future<Either<Failure, Comic>> getComic({required int comicNum});

   ///get all comics
  ///returns either <Failure, Comic>
  Future<Either<Failure, List<Comic>>> getAllComics();

  ///save a comic locally
  ///returns either <Failure, String>
  Future<Either<Failure, String>> saveComic({required int comicNum});

  ///save a comic locally
  ///returns either <Failure, String>
  Future<Either<Failure, List<Comic>>> loadSavedComics();

  ///search a comic by num
  ///returns either <Failure, Comic>
  Future<Either<Failure, Comic>> searchComicbyNum({required int comicNum});

  ///search a comic by text
  ///returns either <Failure, Comic>
  Future<Either<Failure, Comic>> searchComicbyText({required String text});

  ///share a comic
  ///returns either <Failure, String>
  Future<Either<Failure, String>> shareComic({required int comicNum});

  ///get comic details
  ///returns either <Failure, String>
  Future<Either<Failure, JSON>> getComicDetails({required int comicNum});

  ///get comic explaination
  ///returns either <Failure, String>
  Future<Either<Failure, String>> getComicExplanation({required int comicNum});

  ///get new comic notification
  ///returns either <Failure, String>
  Future<Either<Failure, String>> getComicNotification();
  
}