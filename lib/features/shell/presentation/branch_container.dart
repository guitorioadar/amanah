import 'package:flutter/material.dart';

/// Stacks all shell branches and cross-fades between them on tab change: the
/// outgoing branch fades out while the incoming fades in (both animate at once).
/// Every branch stays mounted so its scroll/search state is preserved.
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
          AnimatedOpacity(
            opacity: i == currentIndex ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
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
