import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/localization/l10n/generated/app_localizations.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_bloc.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_event.dart';
import 'package:learning_assistant/features/comics/presentation/bloc/comic_state.dart';
import 'package:learning_assistant/features/comics/presentation/pages/comic_detail_page.dart';
import 'package:learning_assistant/shared/widgets/gradient_scaffold.dart';

class ComicSearchPage extends StatefulWidget {
  const ComicSearchPage({super.key});

  @override
  State<ComicSearchPage> createState() => _ComicSearchPageState();
}

class _ComicSearchPageState extends State<ComicSearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return GradientScaffold(
      appBar: AppBar(title: Text("${tr.search} ${tr.comics}"), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Search by number or text',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                if (isInputNum(value)){
                  context.read<ComicBloc>().add(ComicSearchNumRequest(num: int.parse(value)));
                } else{
                  context.read<ComicBloc>().add(ComicSearchTextRequest(text: value));
                }                
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ComicBloc, ComicState>(
                builder: (context, state) {
                  if (state is ComicSearchingByNumState) {
                    return const Center(child: Text('Enter a number or text'));
                  } else if (state is ComicSearchingByNumState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ComicFoundState) {
                    if (state is ComicNotFoundState) {
                      return const Center(child: Text('No comics found'));
                    }
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        final comic = state.comic;
                        return ListTile(
                          leading: comic.localImage != null && comic.localImage!.isNotEmpty
                              ? Image.file(File(comic.localImage!), width: 50, height: 50)
                              : Image.network(comic.img, width: 50, height: 50),
                          title: Text('#${comic.num} ${comic.title}'),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder:  (_) => ComicDetailPage(comic: comic)));
                          },
                        );
                      },
                    );
                  } else if (state is ComicNotFoundState) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool isInputNum(String input) {
    final numValue = num.tryParse(input);
    return numValue == null ? false : true;
  }
}
