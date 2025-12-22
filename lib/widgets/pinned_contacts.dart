// Pinned Contacts Widget
//
// Horizontal row of favorite/pinned contacts for quick access.
// Shows large avatars with names below.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class PinnedContactsRow extends StatelessWidget {
  final List<PinnedContactData> contacts;
  final ValueChanged<PinnedContactData>? onContactTap;

  const PinnedContactsRow({
    super.key,
    required this.contacts,
    this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    if (contacts.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
        itemCount: contacts.length > 4 ? 4 : contacts.length,
        separatorBuilder: (_, __) => SizedBox(width: theme.spacingL),
        itemBuilder: (context, index) {
          return PinnedContactItem(
            contact: contacts[index],
            onTap: () => onContactTap?.call(contacts[index]),
          );
        },
      ),
    );
  }
}

class PinnedContactItem extends StatefulWidget {
  final PinnedContactData contact;
  final VoidCallback? onTap;

  const PinnedContactItem({super.key, required this.contact, this.onTap});

  @override
  State<PinnedContactItem> createState() => _PinnedContactItemState();
}

class _PinnedContactItemState extends State<PinnedContactItem>
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
      end: 0.92,
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
    final contact = widget.contact;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        HapticFeedback.selectionClick();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar with subtle elevation
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      contact.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: theme.mutedPrimary,
                        child: Icon(
                          Icons.person,
                          color: theme.textSecondary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: theme.spacingS),
                // Name
                Text(
                  contact.firstName,
                  style: theme.bodySmall.copyWith(
                    color: contact.isActive
                        ? theme.secondaryAccent
                        : theme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PinnedContactData {
  final String id;
  final String firstName;
  final String avatarUrl;
  final bool isActive;

  const PinnedContactData({
    required this.id,
    required this.firstName,
    required this.avatarUrl,
    this.isActive = false,
  });
}
