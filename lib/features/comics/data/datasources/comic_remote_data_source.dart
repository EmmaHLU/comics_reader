import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:learning_assistant/features/comics/data/models/comic_model.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/utils/constants.dart';

abstract class ComicRemoteDataSource {

  ///get comic by num
  /// Throws [CacheException] on failure
  Future<ComicModel> getComic({required int num});

  ///get comic list
  /// Throws [CacheException] on failure
  Future<List<ComicModel>> getComicList();

  ///search comic by num
  /// Throws [CacheException] on failure
  Future<ComicModel> searchComicByNum({required int num});

   ///search comic by text
  /// Throws [CacheException] on failure
  Future<ComicModel> searchComicByText({required String text});

  ///share comic by num
  /// Throws [CacheException] on failure
  Future<void> shareComic({required int num});

  ///explain comic by num
  /// Throws [CacheException] on failure
  Future<String> explainComic({required int num, required String title});

}

class ComicRemoteDataSourceImpl implements ComicRemoteDataSource{
  //lazy loading mode list size
  final int listSize = 50;

  /// Local cache of all comics loaded so far
  List<ComicModel> cachedComics = [];

  ///indicator of current comic num
  int currentComicNum = -1;

  ///total num of comics
  int totalComicNum = 0;

  @override
  Future<String> explainComic({required int num, required String title}) async {
    // Build the correct page title, e.g., "3165:_Earthquake_Prediction_Flowchart"
    final pageTitle = '${num}:_${title.replaceAll(" ", "_")}';
    final url = Uri.parse('${AppConstants.explainBase}?action=parse&page=$pageTitle&format=json');

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      print(data['parse']?['text']);
      final html = data['parse']?['text']?['*'] ?? '';
      return html;
    } else {
      throw Exception('Failed to fetch explanation for comic $num');
    }
  }


  @override
  Future<ComicModel> getComic({required int num}) async {
    final res = await http.get(Uri.parse('${AppConstants.baseXkcd}/$num/info.0.json'));
    if (res.statusCode == 200) {
      return ComicModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to fetch comic $num');
    }
  }

  @override
  Future<List<ComicModel>> getComicList() async {
    const int pageSize = 5;

    // Fetch the latest comic number (only needed for the first list)
    if (currentComicNum == -1) {
      final latestRes = await http.get(Uri.parse('${AppConstants.baseXkcd}/info.0.json'));
      if (latestRes.statusCode != 200) {
        throw Exception('Failed to fetch the latest comic');
      }
      final latestComic = ComicModel.fromJson(jsonDecode(latestRes.body));
      currentComicNum = latestComic.num;
      totalComicNum = latestComic.num;
    }

    // Calculate the range of comics to fetch for this list
    final startNum = currentComicNum - 1;
    final endNum = (startNum - pageSize + 1).clamp(1, startNum);

    // Fetch comics from newest to oldest within this range
    final comics = <ComicModel>[];
    for (int i = startNum; i >= endNum; i--) {
      try {
        final comic = await getComic(num: i);
        comics.add(comic);
      } catch (_) {
        // Some comic numbers may not exist; skip those
      }
    }
    currentComicNum = endNum - 1;
    cachedComics.addAll(comics);
    return cachedComics;
  }


  @override
  Future<ComicModel> searchComicByNum({required int num}) async {
    return getComic(num: num);
  }

  @override
  Future<ComicModel> searchComicByText({required String text}) async {
    final url = Uri.parse('${AppConstants.searchBase}?action=xkcd&query=$text');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final lines = res.body.split('\n');
      if (lines.length < 3) throw Exception('No comics found for "$text"');
      final firstResult = lines[2].split(' ');
      final num = int.tryParse(firstResult[1]);
      if (num != null) {
        return getComic(num: num);
      }
      throw Exception('Invalid search result');
    } else {
      throw Exception('Search failed for "$text"');
    }
  }

  @override
  Future<void> shareComic({required int num}) async {
    final link = 'https://xkcd.com/$num';
    final result = SharePlus.instance.share(ShareParams(
      uri: Uri.parse(link),
      subject: 'XKCD Comic #$num',
    ),);
  }
  
  
}