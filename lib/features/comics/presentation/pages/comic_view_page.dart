
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_event.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_state.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_detail_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_explain_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_favoriate_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_share_button.dart';
import 'package:learning_assistant/shared/widgets/fancy_card.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';

class ComicViewPage extends StatefulWidget{
  final Comic comic;

  const ComicViewPage({
    super.key, 
    required this.comic,
  });

  @override
  State<StatefulWidget> createState() => _ComicViewPageState();
  
}

class _ComicViewPageState extends State<ComicViewPage>{
  late PageController pageController;
  late Comic comic;
  late int curIndex;
  late int oldIndex;

  @override
  void initState()
  {
    super.initState();
    comic = widget.comic;
    curIndex = comic.num;
    pageController = PageController(initialPage: curIndex);
  }
  
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return BlocBuilder<ComicBloc, ComicState>(
      buildWhen: (previous, current)=>current is ComicLoadingState || current is ComicLoadedState || current is ComicFailedState,
      builder: (context, state){
        if (state is ComicLoadingState){
          return const Center(child: CircularProgressIndicator(),);
        } else if(state is ComicLoadedState){
          final comic = state.comic;
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
                ComicShareButton(comicNum: comic.num),
                ComicFavoriateButton(comicNum: comic.num),
                ComicExplainButton(comicNum: comic.num, title: comic.safeTitle!,),
                ComicDetailButton(comic: comic,),
              ],
              backgroundColor: Colors.transparent,
            ),
            body: PageView.builder(
              controller:pageController,
              onPageChanged: (value) => {
                context.read<ComicBloc>().add(ComicGetRequest(num:value)),
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
                          child: (comic.localImage ?? '').isNotEmpty
                            ? Image.file(
                                File(comic.localImage!),
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                            comic.img)),
                          ),
                        
                        const SizedBox(height: 8),
                        Text(
                          comic.title!,
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
        }else if (state is ComicFailedState){
          return Center(child: Text("Error loading comic"),);
        } else{
          return const SizedBox.shrink();
        }
      },
    );
  }
}
  