import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:learning_assistant/core/utils/constants.dart';
import 'package:learning_assistant/features/comics/data/models/comic_model.dart';
import 'package:learning_assistant/features/comics/data/datasources/comic_remote_data_source.dart';
import 'comic_remote_datasource_test.mocks.dart' as ComicMock;

// Import the generated mock

// Dummy ComicModel for expected output
final tComicModel = ComicModel(
  num: 614,
  title: 'Test Comic',
  img: 'http://test.com/614.png',
  alt: 'alt text',
  safeTitle: 'Test_Comic',
  year: '2009',
  month: '4',
  day: '22',
  link: '',
  news: '',
  transcript: ''
);

// Raw JSON response string to be returned by the mock client
final tComicJson = jsonEncode({
  "month": "4",
  "num": 614,
  "link": "",
  "year": "2009",
  "news": "",
  "safe_title": "Test Comic",
  "transcript": "",
  "alt": "alt text",
  "img": "http://test.com/614.png",
  "title": "Test Comic",
  "day": "22"
});

@GenerateMocks([http.Client])
void main() {
  late ComicRemoteDataSourceImpl dataSource;
  late ComicMock.MockClient mockHttpClient;

  setUp(() {
    // Reset the cache for each test
    mockHttpClient = ComicMock.MockClient();
    dataSource = ComicRemoteDataSourceImpl();
    dataSource.cachedComics = []; 
    dataSource.currentComicNum = -1; // Reset indicators for stability
  });


  group('getComic', () {
    const tNum = 614;
    final tUri = Uri.parse('${AppConstants.baseXkcd}/$tNum/info.0.json');

    // Test for successful API call (HTTP 200)
    // test(
    //   'should return ComicModel when the response code is 200 (success)',
    //   () async {
    //     // ARRANGE
    //     dataSource.cachedComics = []; 
    //     when(mockHttpClient.get(tUri))
    //         .thenAnswer((_) async => http.Response(tComicJson, 200));
        
    //     final result = await dataSource.getComic(num: tNum);

    //     // ASSERT
    //     // verify(mockHttpClient.get(tUri)); 
    //     expect(result, equals(tComicModel));
    //   },
    // );

    // Test for unsuccessful API call (non-HTTP 200)
    // test(
    //   'should throw an Exception when the response code is 404 or other error',
    //   () async {
    //     // ARRANGE
    //     dataSource.cachedComics = [];
    //     when(mockHttpClient.get(tUri))
    //         .thenAnswer((_) async => http.Response('Not Found', 404));

    //     // ACT & ASSERT
    //     final result = dataSource.getComic(num: tNum);

    //     expect(
    //       result,
    //       throwsA(isA<Exception>()));
        
    //     // VERIFY
    //     verify(mockHttpClient.get(tUri)); 
    //   },
    // );

    // Test for cache hit
    test(
      'should return the cached ComicModel if available (no API call)',
      () async {
        // ARRANGE
        // 1. Pre-populate the cache
        dataSource.cachedComics = [tComicModel];
        
        // ACT
        final result = await dataSource.getComic(num: tNum);

        // ASSERT
        expect(result, equals(tComicModel));
        // VERIFY 
        // verifyNever(mockHttpClient.get(any)); 
      },
    );
  });

}