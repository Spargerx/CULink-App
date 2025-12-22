// Story Circle Widget
//
// Circular avatar with gradient ring for stories.
// Supports "My Story" variant with add button.

import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

class StoryCircle extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool hasUnseenStory;
  final bool isMyStory;
  final VoidCallback? onTap;

  const StoryCircle({
    super.key,
    required this.imageUrl,
    required this.name,
    this.hasUnseenStory = false,
    this.isMyStory = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final size = theme.storyCircleSize;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // Gradient ring container
              Container(
                width: size,
                height: size,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: hasUnseenStory || isMyStory
                      ? theme.primaryGradient
                      : null,
                  color: hasUnseenStory || isMyStory
                      ? null
                      : theme.mutedSecondary,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.backgroundLight, width: 3),
                    color: theme.mutedPrimary,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.mutedSecondary,
                          child: Icon(
                            Icons.person,
                            color: theme.textSecondary,
                            size: size * 0.4,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: theme.mutedPrimary,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.primaryAccent,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // Add button for "My Story"
              if (isMyStory)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: theme.secondaryAccent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.backgroundLight,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
            ],
          ),
          SizedBox(height: theme.spacingS),
          SizedBox(
            width: size,
            child: Text(
              isMyStory ? 'My Story' : name,
              style: theme.labelSmall.copyWith(
                color: theme.textPrimary.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal scrollable stories row
class StoriesRow extends StatelessWidget {
  final List<StoryData> stories;
  final StoryData? myStory;

  const StoriesRow({super.key, required this.stories, this.myStory});

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return SizedBox(
      height: theme.storyCircleSize + 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
        itemCount: stories.length + (myStory != null ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(width: theme.spacingM),
        itemBuilder: (context, index) {
          if (myStory != null && index == 0) {
            return StoryCircle(
              imageUrl: myStory!.imageUrl,
              name: myStory!.name,
              isMyStory: true,
              hasUnseenStory: myStory!.hasUnseenStory,
            );
          }
          final storyIndex = myStory != null ? index - 1 : index;
          final story = stories[storyIndex];
          return StoryCircle(
            imageUrl: story.imageUrl,
            name: story.name,
            hasUnseenStory: story.hasUnseenStory,
          );
        },
      ),
    );
  }
}

/// Data model for stories
class StoryData {
  final String imageUrl;
  final String name;
  final bool hasUnseenStory;

  const StoryData({
    required this.imageUrl,
    required this.name,
    this.hasUnseenStory = false,
  });
}
