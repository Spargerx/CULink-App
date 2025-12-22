// Post Card Widget
//
// A glassmorphic card for displaying feed posts.
// Includes user info, image, title, description, and interactions.

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import 'responsive_button.dart';

class PostCard extends StatefulWidget {
  final PostData post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onFollow;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onFollow,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _hoverController.forward(),
            onTapUp: (_) => _hoverController.reverse(),
            onTapCancel: () => _hoverController.reverse(),
            child: Container(
              decoration: BoxDecoration(
                color: theme.backgroundLight,
                borderRadius: BorderRadius.circular(theme.radiusLarge),
                border: theme.cardBorder,
                boxShadow: theme.cardShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(theme.radiusLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User header
                    _buildHeader(context),
                    // Post image
                    _buildImage(context),
                    // Content
                    _buildContent(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = context.cuTheme;
    final post = widget.post;

    return Padding(
      padding: EdgeInsets.all(theme.spacingM),
      child: Row(
        children: [
          // Avatar
          Container(
            width: theme.avatarLarge,
            height: theme.avatarLarge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.primaryAccent, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                post.userAvatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.mutedPrimary,
                    child: Icon(Icons.person, color: theme.textSecondary),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: theme.spacingM),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: theme.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  post.userHandle,
                  style: theme.bodySmall.copyWith(color: theme.textSecondary),
                ),
              ],
            ),
          ),
          // Follow button
          ResponsiveTextButton(text: 'Follow', onTap: widget.onFollow),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = context.cuTheme;

    return SizedBox(
      height: theme.postImageHeight,
      width: double.infinity,
      child: Image.network(
        widget.post.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: theme.mutedPrimary,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: theme.textSecondary,
                size: 48,
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: theme.mutedPrimary,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
                color: theme.primaryAccent,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = context.cuTheme;
    final post = widget.post;

    return Padding(
      padding: EdgeInsets.all(theme.spacingM + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(post.title, style: theme.heading2),
          SizedBox(height: theme.spacingS),
          // Description
          Text(
            post.description,
            style: theme.bodyMedium.copyWith(
              color: theme.textPrimary.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: theme.spacingM),
          // Action buttons
          Row(
            children: [
              _ActionButton(
                icon: Icons.favorite,
                iconColor: theme.primaryAccent,
                label: post.likesFormatted,
                onTap: widget.onLike,
              ),
              SizedBox(width: theme.spacingS),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: post.commentsFormatted,
                onTap: widget.onComment,
              ),
            ],
          ),
          // Featured comment
          if (post.featuredComment != null) ...[
            SizedBox(height: theme.spacingM),
            _buildFeaturedComment(context),
          ],
        ],
      ),
    );
  }

  Widget _buildFeaturedComment(BuildContext context) {
    final theme = context.cuTheme;
    final comment = widget.post.featuredComment!;

    return Container(
      padding: EdgeInsets.all(theme.spacingM),
      decoration: BoxDecoration(
        color: theme.mutedPrimary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(theme.radiusMedium),
      ),
      child: Row(
        children: [
          // Commenter avatar
          Container(
            width: theme.avatarSmall,
            height: theme.avatarSmall,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.network(
                comment.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.mutedSecondary,
                    child: Icon(
                      Icons.person,
                      size: 12,
                      color: theme.textSecondary,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: theme.spacingS),
          // Comment text
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.bodySmall,
                children: [
                  TextSpan(
                    text: '${comment.userName}: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: '"${comment.text}"',
                    style: TextStyle(
                      color: theme.textPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Action button for likes/comments
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    this.iconColor,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return ResponsiveButton(
      onTap: onTap,
      backgroundColor: Colors.transparent,
      boxShadow: [],
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacingS,
        vertical: theme.spacingXS,
      ),
      borderRadius: BorderRadius.circular(theme.radiusFull),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor ?? theme.textSecondary, size: 20),
          SizedBox(width: theme.spacingXS),
          Text(
            label,
            style: theme.labelMedium.copyWith(
              color: theme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model for posts
class PostData {
  final String userName;
  final String userHandle;
  final String userAvatarUrl;
  final String imageUrl;
  final String title;
  final String description;
  final int likes;
  final int comments;
  final CommentData? featuredComment;

  const PostData({
    required this.userName,
    required this.userHandle,
    required this.userAvatarUrl,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.likes,
    required this.comments,
    this.featuredComment,
  });

  String get likesFormatted => _formatCount(likes);
  String get commentsFormatted => _formatCount(comments);

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

/// Data model for comments
class CommentData {
  final String userName;
  final String avatarUrl;
  final String text;

  const CommentData({
    required this.userName,
    required this.avatarUrl,
    required this.text,
  });
}
