import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/core/utils/typedefs.dart';
import 'package:learning_assistant/features/comics/data/datasources/comic_local_data_source.dart';
import 'package:learning_assistant/features/comics/data/datasources/comic_remote_data_source.dart';
import 'package:learning_assistant/features/comics/data/models/comic_model.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/domain/repositories/comic_repository.dart';

class ComicRepositoryImpl implements ComicRepository{
  final ComicRemoteDataSource remoteDataSource;
  final ComicLocalDataSource localDataSource;

  
  ComicRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource
  });

  /// Get paginated list of comics (50 per page)
  @override
  Future<Either<Failure, List<Comic>>> getComicList() async {
    try {
      // Fetch comic list
      final models = await remoteDataSource.getComicList();
      final comics = models.map((m) => m.toEntity()).toList();
      return Right(List.unmodifiable(comics));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comic>> getComic({required int comicNum}) async {
    try {
      ComicModel comicModel = await remoteDataSource.getComic(num: comicNum);
      if(await localDataSource.isFavorite(comicNum: comicModel.num))
      {
        Map<String, dynamic> jsonfile = comicModel.toJson();
        jsonfile['isFavorite'] = true;
        comicModel = ComicModel.fromJson(jsonfile);
      }
      return Right(comicModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JSON>> getComicDetails({required int comicNum}) async {
    try {
      final comicModel = await remoteDataSource.getComic(num: comicNum);
      return Right(comicModel.toJson()); // assuming toJson() exists
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getComicExplanation({required int comicNum, required String title}) async {
    try {
      final explanation = await remoteDataSource.explainComic(num: comicNum,title:title);
      return Right(explanation);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comic>>> loadSavedComics() async {
    try {
      final comics = await localDataSource.loadSavedComics();
      return Right(comics.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveComic({required int comicNum}) async {
    try {
      final comic = await remoteDataSource.getComic(num: comicNum);
      
    await localDataSource.saveComic(comic:comic);
      return Right('Comic saved successfully');
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteComic({required int comicNum}) async {
    try {
      // Get the comic from local storage first
      final comic = await localDataSource.loadSavedComic(num: comicNum);

      // Delete the image file if it exists
      if (comic.localImage != null && comic.localImage!.isNotEmpty) {
        final file = File(comic.localImage!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Remove comic data from local database / storage
      await localDataSource.deleteSavedComic(num: comicNum);

      return const Right('Comic deleted successfully');
    } catch (e) {
      return Left(CacheFailure('Failed to delete comic: $e'));
    }
  }

  @override
  Future<Either<Failure, Comic>> searchComicbyNum({required int comicNum}) async {
    try {
      final comicModel = await remoteDataSource.searchComicByNum(num: comicNum);
      return Right(comicModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Comic>> searchComicbyText({required String text}) async {
    try {
      final comicModel = await remoteDataSource.searchComicByText(text: text);
      return Right(comicModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> shareComic({required int comicNum}) async {
    try {
      await remoteDataSource.shareComic(num: comicNum);
      return Right('Comic shared successfully');
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
}