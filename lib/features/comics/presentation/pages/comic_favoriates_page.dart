import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/features/comics/domain/entities/comic_entity.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_event.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_state.dart';
import 'package:learning_assistant/features/comics/presentation/pages/comic_view_page.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_detail_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_explain_button.dart';
import 'package:learning_assistant/features/comics/presentation/widgets/comic_share_button.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';

class FavoriatePage extends StatefulWidget {

  // Action callbacks
  final void Function(int)? onTap;


  const FavoriatePage({
    super.key,
    this.onTap,
  });

  @override
  State<FavoriatePage> createState() => _FavoriatePageState();
}

class _FavoriatePageState extends State<FavoriatePage> {
  final ScrollController _scrollController = ScrollController();
  List<Comic> comics = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComicBloc>().add(ComicLoadFavoriatesRequest());
    });
    
    return BlocConsumer<ComicBloc, ComicState>(
      listener: (context, state) {
        if (state is ComicFavoriateLoadedState) {
          comics = state.comics;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        } else if (state is ComicFavoriateLFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to load my favoriates")),
          );
        };   
      },
      builder:  (context, state) {
        if (state is ComicFavoriateLoadingState){
          return const Center(child: CircularProgressIndicator(),);
        }
        return GradientScaffold(
          appBar: AppBar(
            title: Text("My Favoriates"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Safely go back
              },            
            ),
            backgroundColor: Colors.transparent,
            actions: [
             IconButton(
              onPressed: (){context.read<ComicBloc>().add(ComicLoadFavoriatesRequest());}, 
              icon: Icon(Icons.refresh)),
            ],
          ),
          body:ListView.builder(
            controller: _scrollController,
            itemCount: comics.length, // extra item for load more button
            itemBuilder: (context, index) {

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
                  Navigator.push(context,  MaterialPageRoute(builder:  (_) => ComicViewPage(comic: comic,)));
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ComicShareButton(comicNum: comic.num),
                    ComicExplainButton(comicNum: comic.num, title: comic.safeTitle!,),
                    ComicDetailButton(comic: comic)
                  ],
                ),
              );
            },
          )
        );
      }
    );
  }
}
