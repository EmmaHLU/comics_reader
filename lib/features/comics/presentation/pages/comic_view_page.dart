
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

class ComicViewPage extends StatefulWidget {
  final Comic comic;
  final int totalComicNum;

  const ComicViewPage({
    super.key,
    required this.comic,
    required this.totalComicNum,
  });

  @override
  State<ComicViewPage> createState() => _ComicViewPageState();
}

class _ComicViewPageState extends State<ComicViewPage> {
  late int curIndex;

  @override
  void initState() {
    super.initState();
    curIndex = widget.comic.num; 
    _loadComic(curIndex);
  }

  void _loadComic(int num) {
    context.read<ComicBloc>().add(ComicGetRequest(num: num));
  }

  void _onSwipeLeft() {
    if (curIndex > 1) { 
      setState(() {
        curIndex -= 1;
      });
      _loadComic(curIndex);
    }
  }

  void _onSwipeRight() {
    if (curIndex < widget.totalComicNum) {
      setState(() {
        curIndex += 1;
      });
      _loadComic(curIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return BlocBuilder<ComicBloc, ComicState>(
      buildWhen: (previous, current)=>current is ComicLoadingState || current is ComicLoadedState || current is ComicFailedState,
      builder: (context, state) {
        Widget content;

        if (state is ComicLoadingState) {
          content = const Center(child: CircularProgressIndicator());
        } else if (state is ComicLoadedState) {
          final comic = state.comic;
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "${comic.num}/${widget.totalComicNum}", 
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,),
              Expanded(
                child: RippleFancyCard(child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(comic.img),
                ),)),
              const SizedBox(height: 8),
              Text(
                comic.title!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          );
        } else {
          content = Center(child: Text(tr.errorloading));
        }

        return GradientScaffold(
          appBar: AppBar(
            title: Text(tr.comics),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (state is ComicLoadedState) ...[
                ComicShareButton(comicNum: state.comic.num),
                ComicFavoriateButton(comicNum: state.comic.num, isFavoriateInitially:state.comic.isFavorite!),
                ComicExplainButton(
                  comicNum: state.comic.num,
                  title: state.comic.safeTitle!,
                ),
                ComicDetailButton(comic: state.comic),
              ]
            ],
            backgroundColor: Colors.transparent,
          ),
          body: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity == null) return;

              if (details.primaryVelocity! < 0) {
                _onSwipeLeft();
              } else if (details.primaryVelocity! > 0) {
                _onSwipeRight();
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
              child: content,
            ),
          ),
        );
      },
    );
  }
}
