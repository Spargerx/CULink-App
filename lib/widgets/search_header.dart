// Search Header Widget
//
// Floating pill-shaped search bar with frosted glass effect.
// Includes horizontally scrollable filter chips.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class SearchHeader extends StatelessWidget {
  final String hintText;
  final List<FilterChipData> filters;
  final int selectedFilterIndex;
  final ValueChanged<int>? onFilterSelected;
  final ValueChanged<String>? onSearchChanged;

  const SearchHeader({
    super.key,
    this.hintText = 'Search...',
    this.filters = const [],
    this.selectedFilterIndex = -1,
    this.onFilterSelected,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Column(
      children: [
        // Floating search bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: theme.spacingL),
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacingM,
            vertical: theme.spacingS,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(theme.radiusFull),
            border: Border.all(
              color: theme.mutedPrimary.withValues(alpha: 0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.radiusFull),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: theme.textSecondary,
                    size: 22,
                  ),
                  SizedBox(width: theme.spacingS),
                  Expanded(
                    child: TextField(
                      onChanged: onSearchChanged,
                      style: theme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: theme.bodyMedium.copyWith(
                          color: theme.textSecondary,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: theme.spacingS,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Filter chips
        if (filters.isNotEmpty) ...[
          SizedBox(height: theme.spacingM),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
              itemCount: filters.length,
              separatorBuilder: (_, __) => SizedBox(width: theme.spacingS),
              itemBuilder: (context, index) {
                final isSelected = index == selectedFilterIndex;
                return _FilterChip(
                  label: filters[index].label,
                  isSelected: isSelected,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onFilterSelected?.call(index);
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FilterChip({required this.label, this.isSelected = false, this.onTap});

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: theme.durationFast,
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacingM,
                vertical: theme.spacingS,
              ),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? theme.secondaryAccent
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(theme.radiusFull),
                border: Border.all(
                  color: widget.isSelected
                      ? theme.secondaryAccent
                      : theme.primaryAccent.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Text(
                widget.label,
                style: theme.labelSmall.copyWith(
                  color: widget.isSelected ? Colors.white : theme.primaryAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FilterChipData {
  final String label;
  final String? value;

  const FilterChipData({required this.label, this.value});
}
