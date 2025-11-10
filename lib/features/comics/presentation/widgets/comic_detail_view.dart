import 'package:flutter/material.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';


  Widget buildMetadataTable(Comic comic, BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final entries = {
      tr.num: comic.num.toString(),
      tr.title: comic.title,
      tr.safe_title: comic.safeTitle,
      tr.year: comic.year,
      tr.month: comic.month,
      tr.day: comic.day,
      tr.img: comic.img,
      tr.news: comic.news,
      tr.link: comic.link,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.details,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: entries.entries
                  .where((e) => e.value!.isNotEmpty)
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: SelectableText(entry.value!),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
