
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_detail_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_explain_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_favoriate_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_share_button.dart';
import 'package:learning_assistant/shared/widgets/fancy_card.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';

class ComicLocalViewPage extends StatefulWidget{
  final List<Comic> comics;
  final int index;

  const ComicLocalViewPage({
    super.key, 
    required this.comics,
    required this.index,
  });

  @override
  State<StatefulWidget> createState() => _ComicLocalViewPageState();
  
}

class _ComicLocalViewPageState extends State<ComicLocalViewPage>{
  late PageController pageController;
  late int curIndex;

  @override
  void initState()
  {
    super.initState();
    curIndex = widget.index;
    pageController = PageController(initialPage: curIndex);
  }
  
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return GradientScaffold(
            appBar: AppBar(
              title: Text(tr.comics),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // Safely go back
                },
              ),
              actions: [
                ComicShareButton(comicNum: widget.comics[curIndex].num),
                ComicFavoriateButton(comicNum: widget.comics[curIndex].num),
                ComicExplainButton(comicNum: widget.comics[curIndex].num, title: widget.comics[curIndex].safeTitle!,),
                ComicDetailButton(comic: widget.comics[curIndex],),
              ],
              backgroundColor: Colors.transparent,
            ),
            body: PageView.builder(
              controller:pageController,
              itemCount: widget.comics.length,
              onPageChanged: (value) => {
                setState(() {
                  curIndex = value;
                }),
              },
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
                  child: RippleFancyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: (widget.comics[curIndex].localImage ?? '').isNotEmpty
                            ? Image.file(
                                File(widget.comics[curIndex].localImage!),
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                            widget.comics[curIndex].img)),
                          ),
                        
                        const SizedBox(height: 8),
                        Text(
                          widget.comics[curIndex].title!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ],
                      ),
                    ),
                );
                }
            )
          );
        
  }
}
  