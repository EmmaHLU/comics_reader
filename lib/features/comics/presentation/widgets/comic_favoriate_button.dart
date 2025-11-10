import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_event.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_state.dart';

class ComicFavoriateButton extends StatefulWidget {
  final int comicNum;
  final bool isFavoriateInitially;

  const ComicFavoriateButton({
    super.key,
    required this.comicNum,
    this.isFavoriateInitially = false,
  });

  @override
  State<ComicFavoriateButton> createState() => _ComicFavoriateButtonState();
}

class _ComicFavoriateButtonState extends State<ComicFavoriateButton> {
  late bool isFavoriate;

  @override
  void initState() {
    super.initState();
    isFavoriate = widget.isFavoriateInitially;
  }

  void _toggleFavoriate() {
    setState(() {
      isFavoriate = !isFavoriate;
    });
    // Send save or delete request based on current state
    if (isFavoriate) {
      context.read<ComicBloc>().add(ComicSaveRequest(num: widget.comicNum));
    } else {
      context.read<ComicBloc>().add(ComicDeleteRequest(num: widget.comicNum));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComicBloc, ComicState>(
      
      builder: (context, state)
      {
        return IconButton(
        icon: isFavoriate
            ? const Icon(Icons.favorite, color: Colors.red)
            : const Icon(Icons.favorite_border),
        onPressed: _toggleFavoriate,
        tooltip: "Toggle favorite",
        );
      }
    );
  }
}
