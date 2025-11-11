import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:learning_assistant/core/error/exceptions.dart';
import 'package:learning_assistant/features/comics/data/models/comic_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import '../../../../core/utils/constants.dart';
abstract class ComicLocalDataSource {

  ///save comic by num
  /// Throws [CacheException] on failure
  Future<void> saveComic({required ComicModel comic});

  /// Load saved comic by num from local storage
  /// Throws [NotFoundException] if no comics are saved
  /// Throws [CacheException] on failure
  Future<ComicModel> loadSavedComic({required int num});

  /// delete saved comic by num from local storage
  /// Throws [NotFoundException] if no comics are saved
  /// Throws [CacheException] on failure
  Future<void> deleteSavedComic({required int num});

  /// Load saved comics from local storage
  /// Throws [NotFoundException] if no comics are saved
  /// Throws [CacheException] on failure
  Future<List<ComicModel>> loadSavedComics();

  /// Delete all saved comics from local storage
  /// Throws [NotFoundException] if no comics are saved
  /// Throws [CacheException] on failure
  Future<void> deleteSavedComics();

  Future<bool> isFavorite({required int comicNum});

}

class ComicLocalDataSourceImpl implements ComicLocalDataSource {

  final FavoriateComicDatabase favoriateDB;
  const ComicLocalDataSourceImpl({required this.favoriateDB});
  
  Future<Directory> _getComicsDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final comicsDir = Directory('${dir.path}/${AppConstants.comicsPath}');
    if (!(await comicsDir.exists())) {
      await comicsDir.create(recursive: true);
    }
    return comicsDir;
  }

    /// Helper: Download image bytes from network
  Future<Uint8List> _downloadImageBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download image from $url');
    }
  }

  /// Save both image and JSON data for one comic
  @override
  Future<void> saveComic({required ComicModel comic}) async {
    final dir = await _getComicsDir();

    // Download image from network
    final imageBytes = await _downloadImageBytes(comic.img);
    // print(imageBytes);

    // Save image locally
    final imageDest = File('${dir.path}/${comic.num}.png');
    await imageDest.writeAsBytes(imageBytes, flush: true);
    // Save JSON locally
    final jsonFile = File('${dir.path}/${comic.num}.json');
    await jsonFile.writeAsString(jsonEncode(comic.toJson()));

    // Save as favorite in database
    favoriateDB.saveFavoriteComic(comicNum: comic.num);
  }
  @override
  Future<ComicModel> loadSavedComic({required int num}) async{
    final dir = await _getComicsDir();
    final jsonFile = File('${dir.path}/$num.json');
    final imagePath = '${dir.path}/$num.png';

    if (!await jsonFile.exists()) {
      throw const NotFoundException('No saved comic found');
    }

    final jsonString = await jsonFile.readAsString();
    final jsonData = jsonDecode(jsonString);
    jsonData['imagePath'] = imagePath;
    return ComicModel.fromJson(jsonData);
  }

  /// Load all saved comics
  @override
  Future<List<ComicModel>> loadSavedComics() async {
    final dir = await _getComicsDir();
    final jsonFiles = dir
        .listSync()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => File(f.path));

    List<ComicModel> comics = [];

    for (var file in jsonFiles) {
      final jsonString = await file.readAsString();
      final jsonData = jsonDecode(jsonString);
      final comic = ComicModel.fromJson(jsonData);
      final num = comic.num;
      final imagePath = '${dir.path}/$num.png';
      jsonData['imagePath'] = imagePath;
      comics.add(ComicModel.fromJson(jsonData));
    }

    comics.sort((a, b) => a.num.compareTo(b.num));
    return comics;
  }

  /// Delete one comic by number
  @override
  Future<void> deleteSavedComic({required int num}) async {
    final dir = await _getComicsDir();
    final jsonFile = File('${dir.path}/$num.json');
    final imageFile = File('${dir.path}/$num.png');

    if (await jsonFile.exists()) await jsonFile.delete();
    if (await imageFile.exists()) await imageFile.delete();
    FavoriateComicDatabase._instance.removeFavoriteComic(comicNum: num);
  }

  /// Delete all saved comics
  @override
  Future<void> deleteSavedComics() async {
    final dir = await _getComicsDir();
    final files = dir.listSync();

    for (var file in files) {
      if (file is File) {
        await file.delete();
      }
    }
  }

  @override
  Future<bool> isFavorite({required int comicNum}) async {
    if (await FavoriateComicDatabase._instance.existFavoriteComic(comicNum)){
      return true;
    }
    return false;
  }

}

class FavoriateComicDatabase {
  final _store = StoreRef.main(); // Use main store for simplicity
  late Database _db;

  // Singleton pattern
  static final FavoriateComicDatabase _instance = FavoriateComicDatabase._internal();
  factory FavoriateComicDatabase() => _instance;
  FavoriateComicDatabase._internal();

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = "${dir.path}/${AppConstants.favoritesDatabaseName}";
    _db = await databaseFactoryIo.openDatabase(dbPath);
  }

  Database get database {
    return _db;
  }

  Future<void> saveFavorites({
    required List<int> comics,
  }) async {
    await _store.record('comics').put(_db, comics);
  }

  Future<void> saveFavoriteComic({
    required int comicNum,
  }) async {
    // 1. Read the existing list (or start empty)
    final raw = (await _store.record('comics').get(_db));
    // Normalize into a list of strings
    List<int> comics;
    if (raw is List) {
      comics = List<int>.from(raw);
    } else {
      comics = <int>[];
    }
    // 2) Add only if missing
    if (!comics.contains(comicNum)) {
      comics.add(comicNum);
    }

    // 3. Write back the updated list
    await _store.record('comics').put(_db, comics);

  }

  Future<void> removeFavoriteComic({
    required int comicNum,
  }) async {
    // Read the existing list (or start empty)
    final comics = (await _store.record('comics').get(_db) as List<dynamic>?)
      ?.cast<int>()
      .toList() 
      ?? [];
    // Add the new URL
    comics.remove(comicNum);
    // Write back the updated list
    await _store.record('comics').put(_db, comics);
  }
  Future<void> removeAllFavoriteComics()async {
    await _store.record('comics').put(_db, []);
  }


  Future<List<String>> getFavoriteComics() async {
    final result = await _store.record('comics').get(_db);
    return (result as List?)?.cast<String>().toList() ?? [];
  }


  Future<bool> existFavoriteComic(comicnum) async {
    final result = await _store.record('comics').get(_db);
    return (result as List?)?.contains(comicnum) ?? false;
  }

}
