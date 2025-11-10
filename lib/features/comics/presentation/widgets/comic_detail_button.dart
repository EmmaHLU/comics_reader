import 'package:flutter/material.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/presentation/pages/comic_detail_page.dart';

class ComicDetailButton extends StatelessWidget {
  final Comic comic;

  const ComicDetailButton({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.details_outlined),
          onPressed: () async {
            await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ComicDetailPage(comic: comic),
            ),
          );
      },
          tooltip: "comic detail info",
        );
  }
}
