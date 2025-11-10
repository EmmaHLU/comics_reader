import 'dart:io';

import 'package:flutter/material.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_detail_view.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_explain_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_favoriate_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_share_button.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';

class ComicDetailPage extends StatelessWidget {
  final Comic comic;


  const ComicDetailPage({super.key, required this.comic});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final imageWidget = comic.localImage != null && comic.localImage!.isNotEmpty
    ? Image.file(
        File(comic.localImage!),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 80),
      )
    : Image.network(
        comic.img,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 80),
      );

    return GradientScaffold(
      appBar: AppBar(
        title: Text(tr.details),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Safely go back
          },
        ),
        backgroundColor: Colors.transparent,
        actions: [
          ComicShareButton(comicNum: comic.num),
          ComicFavoriateButton(comicNum: comic.num),
          ComicExplainButton(comicNum: comic.num, title: comic.safeTitle!,)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Image ---
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.grey.shade200,
                child: imageWidget,
              ),
            ),
            const SizedBox(height: 16),

            /// --- Title and Basic Info ---
            Text(
              '#${comic.num} — ${comic.title}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Published: ${comic.year}-${comic.month}-${comic.day}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            /// --- Transcript (if any) ---
            if (comic.transcript!.isNotEmpty)
              ExpansionTile(
                title: const Text("Transcript"),
                initiallyExpanded: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      comic.transcript!,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),

            /// --- Alt Text ---
            if (comic.alt!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"${comic.alt}"',
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            /// --- Metadata Table ---
            buildMetadataTable(comic, context),
          ],
        ),
      ),
    );
  }
}