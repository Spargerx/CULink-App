/// Segmented Control Widget
///
/// A pill-shaped segmented control with sliding active indicator.
/// Used for switching between Direct and Groups in chat.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class SegmentedControl extends StatefulWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int>? onSegmentChanged;

  const SegmentedControl({
    super.key,
    required this.segments,
    this.selectedIndex = 0,
    this.onSegmentChanged,
  });

  @override
  State<SegmentedControl> createState() => _SegmentedControlState();
}

class _SegmentedControlState extends State<SegmentedControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(SegmentedControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _updateAnimation();
      _controller.forward(from: 0);
    }
  }

  void _updateAnimation() {
    final targetPosition = widget.selectedIndex / widget.segments.length;
    _slideAnimation =
        Tween<double>(
          begin: _slideAnimation.value,
          end: targetPosition,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.mutedPrimary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(theme.radiusFull),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth = constraints.maxWidth / widget.segments.length;

          return Stack(
            children: [
              // Sliding pill indicator
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Positioned(
                    left: _slideAnimation.value * constraints.maxWidth,
                    top: 0,
                    bottom: 0,
                    width: segmentWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.backgroundLight,
                        borderRadius: BorderRadius.circular(theme.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Segment labels
              Row(
                children: widget.segments.asMap().entries.map((entry) {
                  final isSelected = entry.key == widget.selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (entry.key != widget.selectedIndex) {
                          HapticFeedback.selectionClick();
                          widget.onSegmentChanged?.call(entry.key);
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: theme.durationFast,
                            style: theme.labelMedium.copyWith(
                              color: isSelected
                                  ? theme.primaryAccent
                                  : theme.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            child: Text(entry.value),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
