import 'package:flutter/material.dart';

class DotLoader extends StatefulWidget {
  const DotLoader({Key? key}) : super(key: key);

  @override
  DotLoaderState createState() => DotLoaderState();
}

class DotLoaderState extends State<DotLoader> with SingleTickerProviderStateMixin {
  late AnimationController dotController;
  late Animation<double> dotAnimation1;
  late Animation<double> dotAnimation2;
  late Animation<double> dotAnimation3;

  @override
  void initState() {
    super.initState();
    dotController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    dotAnimation1 = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: dotController,
        curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );

    dotAnimation2 = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: dotController,
        curve: const Interval(0.33, 0.66, curve: Curves.easeInOut),
      ),
    );

    dotAnimation3 = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.5), weight: 50),
    ]).animate(
      CurvedAnimation(
        parent: dotController,
        curve: const Interval(0.66, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    dotController.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(radius: 8.0, backgroundColor: Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildDot(dotAnimation1),
        _buildDot(dotAnimation2),
        _buildDot(dotAnimation3),     ],
    );
  }
}