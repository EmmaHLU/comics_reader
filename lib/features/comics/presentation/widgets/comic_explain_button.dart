import 'package:flutter/material.dart';
import 'package:learning_assistant/features/comics/presentation/pages/comic_explain_page.dart';

class ComicExplainButton extends StatelessWidget {
  final int comicNum;
  final String title;

  const ComicExplainButton({super.key, required this.comicNum, required this.title});

  @override
  Widget build(BuildContext context) {
     return IconButton(
          icon: const Icon(Icons.info),
          onPressed:() {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ComicExplainPage(comicNum: comicNum,title:title,),
            ),);
                },
          tooltip: "Explaination of the comic",
        );
      }

}
