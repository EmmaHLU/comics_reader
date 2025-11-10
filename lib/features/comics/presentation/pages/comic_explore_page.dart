import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_event.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_state.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_detail_button.dart';
import 'package:learning_assistant/features/comics/presentation/pages/comic_view_page.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';

class ComicExplorePage extends StatefulWidget {

  const ComicExplorePage({
    super.key,
  });

  @override
  State<ComicExplorePage> createState() => _ComicExplorePageState();
}

class _ComicExplorePageState extends State<ComicExplorePage> {
  final ScrollController _scrollController = ScrollController();
  List<Comic> comics = [];
  late final totalComicNum;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    // Trigger fetching the comic list only once
    final bloc = context.read<ComicBloc>();
    if (bloc.state is! ComicsLoadedState) {
      bloc.add(ComicGetListRequest());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return BlocConsumer<ComicBloc, ComicState>(
      listener: (context, state) {
        if (state is ComicsLoadedState) {
          if (isFirst){
            isFirst = false;
            totalComicNum = state.comics[0].num;
          }
          setState(() {
            comics = state.comics;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        } else if (state is ComicFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to save comic.")),
          );
        } 
        if(state is NewComicNotiReceivedState){
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(state.message)),
          );
        }   
      },
      builder:  (context, state) {
        if (state is ComicLoadingState){
          return const Center(child: CircularProgressIndicator(),);
        }
        return GradientScaffold(
          appBar: AppBar(
            title: Text(tr.explore), backgroundColor: Colors.transparent),
          body: ListView.builder(
            controller: _scrollController,
            itemCount: comics.length + 1, // extra item for load more button
            itemBuilder: (context, index) {
              if (index == comics.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: ElevatedButton(
                      onPressed:(){context.read<ComicBloc>().add(ComicGetListRequest());} ,
                      child: Text(tr.loadMore),
                    ),
                  ),
                );
              }

              final comic = comics[index];

              final imageWidget = comic.localImage != ''
                  ? Image.file(File(comic.localImage!), width: 60, height: 60, fit: BoxFit.cover,)
                  : Image.network(comic.img, width: 60, height: 60, fit: BoxFit.cover, 
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 40),);

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageWidget,
                ),
                title: Text(
                  '#${comic.num} — ${comic.title}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: (){
                  context.read<ComicBloc>().add(ComicGetRequest(num: comic.num));
                  print("the total number of comics is $totalComicNum");
                  Navigator.push(context,  MaterialPageRoute(builder:  (_) => ComicViewPage(comic: comic, totalComicNum: totalComicNum,)));
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ComicShareButton(comicNum: comic.num),
                    // ComicFavoriateButton(comicNum: comic.num),
                    // ComicExplainButton(comicNum: comic.num),
                    ComicDetailButton(comic: comic)
                  ],
                ),
              );
            },
          ),
        ); 
      }
    );
  }
}
