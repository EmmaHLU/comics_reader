import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_event.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_state.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';

class ComicExplainPage extends StatelessWidget {
  final int comicNum;
  final String title;

  const ComicExplainPage({super.key, required this.comicNum, required this.title});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComicBloc>().add(ComicExplainRequest(num: comicNum, title: title));
    });
    final tr = AppLocalizations.of(context)!;
    return GradientScaffold(
      appBar: AppBar(
        title: Text(tr.explaination),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Safely go back
          },),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<ComicBloc, ComicState>(
        buildWhen: (previous, current)=>current is ComicExplainingState || current is ComicExplainedState,
        builder: (context, state) {
          if (state is ComicExplainingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ComicExplainedState) {
            return SingleChildScrollView(
              child: Html(data: state.explaination),
            );
          } else if (state is ComicFailedState) {
            return Center(
              child: Text('Failed to load explanation: ${state.failure}'),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
