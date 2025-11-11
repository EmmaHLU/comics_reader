import 'package:flutter_test/flutter_test.dart';
import 'package:learning_assistant/core/error/failures.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/domain/usecases/get_remote_comic.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';


// Import the generated mock (adjust path as needed)
import 'comic_repository_test.mocks.dart';


void main() {
  late GetComic usecase;
  late MockComicRepository mockComicRepository;

  // 1. SETUP: Initialize the UseCase and its mock dependency
  setUp(() {
    mockComicRepository = MockComicRepository();
    usecase = GetComic(mockComicRepository);
  });

  // Dummy data for testing
  const tComicNumber = 42; // The input parameter
  final tComic = Comic(num: tComicNumber, title: 'The Test Comic', img: 'url');
  
  group('GetComic UseCase', () {
    
    test(
      'should get a single Comic from the repository for the given number',
      () async {
        // ARRANGE
        // STUBBING: Define what the mock repository should return on success
        when(mockComicRepository.getComic(comicNum: anyNamed('comicNum')))
            .thenAnswer((_) async => Right(tComic));

        // ACT
        // Call the UseCase with the test parameter
        final result = await usecase.call(tComicNumber);

        // ASSERT
        // Check if the result matches the expected success value (Right(tComic))
        expect(result, Right(tComic));
        
        // VERIFY
        // Ensure the repository's method was called *exactly once* with the correct parameter
        verify(mockComicRepository.getComic(comicNum: tComicNumber));
        
        // Ensure no other methods were called on the mock object
        verifyNoMoreInteractions(mockComicRepository);
      },
    );
    
    test(
      'should return a Failure when the repository call is unsuccessful',
      () async {
        // ARRANGE
        // STUBBING: Define what the mock repository should return on failure
        when(mockComicRepository.getComic(comicNum: anyNamed('comicNum')))
            .thenAnswer((_) async => Left(ServerFailure("server failure"))); 

        // ACT
        final result = await usecase.call(tComicNumber);

        // ASSERT
        // Check if the result matches the expected failure (Left(Failure))
        expect(result, Left(ServerFailure("server failure")));
        
        // VERIFY
        // Ensure the repository's method was still called
        verify(mockComicRepository.getComic(comicNum: tComicNumber));
        
        // Ensure no other methods were called
        verifyNoMoreInteractions(mockComicRepository);
      },
    );
  });
}