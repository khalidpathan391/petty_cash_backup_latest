import 'dart:math' as math;
import 'package:flutter/material.dart';

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
    required this.firstWidget,
    required this.cancelWidget,
    this.firstWidgetBgColor = Colors.purpleAccent,
    this.firstHeight = 50,
    this.firstWidth = 50,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;
  final Widget firstWidget;
  final Widget cancelWidget;
  final Color firstWidgetBgColor;
  final double firstHeight;
  final double firstWidth;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  // OverlayEntry? _overlayEntry;
  bool showOverlay = false; // Track overlay visibility

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
        showOverlay = true;
        // _showOverlay();
      } else {
        _controller.reverse();
        showOverlay = false;
        // _removeOverlay();
      }
    });
  }

  // void _showOverlay() {
  //   _overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: 0,
  //       left: 0,
  //       right: 0,
  //       bottom: 0,
  //       child: GestureDetector(
  //         onTap: _toggle,
  //         behavior: HitTestBehavior.translucent,
  //         child: Container(
  //           color: Colors.amber.withOpacity(.2),
  //         ),
  //       ),
  //     ),
  //   );
  //   Overlay.of(context).insert(_overlayEntry!);
  // }

  // void _removeOverlay() {
  //   _overlayEntry?.remove();
  //   _overlayEntry = null;
  // }

  bool isDrag = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (showOverlay) // so click anywhere on screen and make it close
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        Positioned(
          bottom: isDrag ? 200 : 0,
          right: 0,
          child: Draggable(
            feedback: SizedBox(
                height: isDrag ? 250 : 150, width: 150, child: mainWidget()),
            // axis: Axis.vertical,
            childWhenDragging: const SizedBox(),
            onDragEnd: (details) => setState(() {
              isDrag = !isDrag;
            }),
            child: SizedBox(
                height: isDrag ? 250 : 150,
                width: 150,
                // color:Colors.amber.withOpacity(.2),
                child: mainWidget()),
          ),
        ),
      ],
    );
  }

  SizedBox mainWidget() {
    return SizedBox.expand(
      child: Stack(
        alignment: isDrag ? Alignment.centerRight : Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: widget.cancelWidget,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = (isDrag ? 180.0 : 90) / (count - 1);
    if (isDrag) {
      for (var i = count - 1, angleInDegrees = -90.0;
          i >= 0;
          i--, angleInDegrees += step) {
        children.add(
          _ExpandingActionButton(
            directionInDegrees: angleInDegrees,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            isDrag: isDrag,
            index: i,
            count: count,
            child: widget.children[i],
          ),
        );
      }
    } else {
      for (var i = 0, angleInDegrees = 0.0;
          i < count;
          i++, angleInDegrees += step) {
        children.add(
          _ExpandingActionButton(
            directionInDegrees: angleInDegrees,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            isDrag: isDrag,
            index: i,
            count: count,
            child: widget.children[i],
          ),
        );
      }
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        // curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: SizedBox(
            height: widget.firstHeight,
            width: widget.firstWidth,
            child: FloatingActionButton(
              backgroundColor: widget.firstWidgetBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000.0),
              ),
              onPressed: _toggle,
              child: widget.firstWidget,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
    required this.isDrag,
    required this.index,
    required this.count,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;
  final bool isDrag;
  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          isDrag
              ? index == 0 || index == count - 1
                  ? directionInDegrees * (math.pi / 180)
                  : directionInDegrees * (math.pi / 135)
              : directionInDegrees * (math.pi / 180),
          isDrag
              ? index == 0 || index == count - 1
                  ? progress.value * maxDistance * 1.5
                  : progress.value * maxDistance
              : progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: isDrag ? 0 : 4.0 + offset.dy,
          top: isDrag ? 4.0 + offset.dy : null,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.itemBgColor = Colors.white,
    this.itemColor = Colors.black,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final Color itemBgColor;
  final Color itemColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: itemBgColor,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: itemColor,
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    super.key,
    required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      height: isBig ? 128 : 36,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
