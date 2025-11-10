import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_event.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_state.dart';

class ComicShareButton extends StatelessWidget {
  final int comicNum;

  const ComicShareButton({super.key, required this.comicNum});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return BlocConsumer<ComicBloc, ComicState>(
      listener: (context, state) {
        if (state is ComicSharedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Comic shared successfully!")),
          );
        } else if (state is ComicShareFaileddState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to share comic.")),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ComicSharingState;

        return IconButton(
          icon: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.share),
          onPressed: isLoading
              ? null
              : () {
                  context.read<ComicBloc>().add(ComicShareRequest(num: comicNum));
                },
          tooltip: "${tr.share} ${tr.comics}",
        );
      },
    );
  }
}
