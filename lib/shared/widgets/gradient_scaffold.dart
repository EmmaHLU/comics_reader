
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final List<Color>? gradientColors;

  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.surface,
        ];

    return Scaffold(
      // AppBar 渐变
      appBar: appBar != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: appBar,
              ),
            )
          : null,
      // Body
      body: body,
      // Bottom navigation
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}


