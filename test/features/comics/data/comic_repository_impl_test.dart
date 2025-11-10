import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:learning_assistant/features/comics/data/models/comic_model.dart';
import 'package:learning_assistant/features/comics/data/repositories/comic_repository_impl.dart';
import 'package:learning_assistant/core/error/failures.dart';


// import the generated mocks
import 'local_data_test.mocks.dart';
import 'remote_data_test.mocks.dart';
void main() {
  late MockComicRemoteDataSource mockRemoteDataSource;
  late MockComicLocalDataSource mockLocalDataSource;
  late ComicRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockComicRemoteDataSource();
    mockLocalDataSource = MockComicLocalDataSource();
    repository = ComicRepositoryImpl(remoteDataSource: mockRemoteDataSource, localDataSource: mockLocalDataSource);
  });

  group('getComic', () {
    const comicNum = 614;
    final tComicModel = ComicModel(
      num: comicNum,
      title: 'Woodpecker',
      img: 'https://imgs.xkcd.com/comics/woodpecker.png',
    );

    test('should return Comic when data source call is successful', () async {
      // Arrange
      when(mockRemoteDataSource.getComic(num: comicNum))
          .thenAnswer((_) async => tComicModel);

      // Act
      final result = await repository.getComic(comicNum: comicNum);

      // Assert
      expect(result, Right(tComicModel.toEntity()));
      verify(mockRemoteDataSource.getComic(num: comicNum)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Failure when data source throws an exception', () async {
      // Arrange
      when(mockRemoteDataSource.getComic(num: comicNum))
          .thenThrow(Exception('Network error'));

      // Act
      final result = await repository.getComic(comicNum: comicNum);

      // Assert
      expect(result, isA<Left<Failure, dynamic>>());
      verify(mockRemoteDataSource.getComic(num: comicNum)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
