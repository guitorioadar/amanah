import 'package:flutter/material.dart';

/// Stacks all shell branches and slides between them on tab change: each branch
/// is offset horizontally by its distance from the current tab, so the new tab
/// slides in from the correct side while the old slides out. Direction is
/// automatic (moving right slides left, and vice-versa). Every branch stays
/// mounted so its scroll/search state is preserved.
class BranchContainer extends StatelessWidget {
  const BranchContainer({
    required this.currentIndex,
    required this.children,
    super.key,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < children.length; i++)
          AnimatedSlide(
            // Offset is in child-size units: current at 0, left tabs off-screen
            // left (−), right tabs off-screen right (+).
            offset: Offset((i - currentIndex).toDouble(), 0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            child: IgnorePointer(
              ignoring: i != currentIndex,
              // Pause offscreen branches' tickers while hidden.
              child: TickerMode(
                enabled: i == currentIndex,
                child: children[i],
              ),
            ),
          ),
      ],
    );
  }
}
