import 'dart:ui';
import 'package:flutter/material.dart';

class RippleFancyCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final OutlinedBorder? shape;
  final EdgeInsets? margin;


  const RippleFancyCard({
    super.key,
    required this.child,
    this.onTap,
    this.gradientColors,
    this.elevation = 4.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.shape,
    this.margin,
  });

  @override
  State<RippleFancyCard> createState() => _RippleFancyCardState();
}

class _RippleFancyCardState extends State<RippleFancyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rippleAnimation;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _rippleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutSine,
    );
  }

  void _handleTapDown(TapDownDetails details) {
    final box = context.findRenderObject() as RenderBox;
    _tapPosition = box.globalToLocal(details.globalPosition);
    _controller.forward(from: 0);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 动画完成后再跳转
        if (widget.onTap != null) widget.onTap!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultGradient = widget.gradientColors ??
        [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.surface,
        ];

    return GestureDetector(
      onTapDown: _handleTapDown,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // 毛玻璃模糊
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: defaultGradient
                        .map((c) => c.withValues(alpha: 0.3))
                        .toList(), // 半透明渐变
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2), // 毛玻璃边框
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: defaultGradient.first.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: _FancyRipplePainter(
                    progress: _rippleAnimation.value,
                    center: _tapPosition,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3), // 波光效果
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {}, // 避免 InkWell 阻止 GestureDetector
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }

}

class _FancyRipplePainter extends CustomPainter {
  final double progress;
  final Offset? center;
  final Color color;

  _FancyRipplePainter({
    required this.progress,
    required this.center,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (center == null) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 1 - progress)
      ..style = PaintingStyle.fill;

    final radius = progress * size.width * 1.2;
    canvas.drawCircle(center!, radius, paint);
  }

  @override
  bool shouldRepaint(_FancyRipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

