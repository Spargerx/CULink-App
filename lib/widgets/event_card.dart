// Event Card Widget
//
// Embedded invite/event card for meetups and plans.
// Appears as a special message bubble in conversations.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class EventCard extends StatelessWidget {
  final EventData event;
  final bool isOutgoing;
  final VoidCallback? onAccept;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.isOutgoing = true,
    this.onAccept,
    this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacingL,
        vertical: theme.spacingS,
      ),
      child: Align(
        alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(
              // Use 80% of width but cap at 320px for wide screens
              maxWidth: MediaQuery.of(context).size.width * 0.8 > 320
                  ? 320
                  : MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(theme.radiusLarge),
              border: Border.all(
                color: theme.secondaryAccent.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.secondaryAccent.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Map preview
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: theme.mutedPrimary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(theme.radiusLarge),
                      topRight: Radius.circular(theme.radiusLarge),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Simulated map pattern
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(theme.radiusLarge),
                          topRight: Radius.circular(theme.radiusLarge),
                        ),
                        child: CustomPaint(
                          size: const Size(double.infinity, 120),
                          painter: _MapPatternPainter(
                            color: theme.mutedSecondary,
                          ),
                        ),
                      ),
                      // Location pin
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.primaryAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryAccent.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      // Event type badge
                      Positioned(
                        top: theme.spacingS,
                        left: theme.spacingS,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: theme.spacingS,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(
                              theme.radiusFull,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                event.emoji,
                                style: const TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 4),
                              Text(
                                event.type,
                                style: theme.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.all(theme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: theme.heading3.copyWith(fontSize: 16),
                      ),
                      SizedBox(height: theme.spacingXS),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: theme.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            event.time,
                            style: theme.bodySmall.copyWith(
                              color: theme.textSecondary,
                            ),
                          ),
                          SizedBox(width: theme.spacingM),
                          Icon(
                            Icons.place_outlined,
                            size: 14,
                            color: theme.textSecondary,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: theme.bodySmall.copyWith(
                                color: theme.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: theme.spacingM),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: _EventButton(
                              label: 'Accept',
                              isFilled: true,
                              color: theme.secondaryAccent,
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                onAccept?.call();
                              },
                            ),
                          ),
                          SizedBox(width: theme.spacingS),
                          Expanded(
                            child: _EventButton(
                              label: 'Edit',
                              isFilled: false,
                              color: theme.textSecondary,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                onEdit?.call();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventButton extends StatefulWidget {
  final String label;
  final bool isFilled;
  final Color color;
  final VoidCallback? onTap;

  const _EventButton({
    required this.label,
    required this.isFilled,
    required this.color,
    this.onTap,
  });

  @override
  State<_EventButton> createState() => _EventButtonState();
}

class _EventButtonState extends State<_EventButton>
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
            child: Container(
              padding: EdgeInsets.symmetric(vertical: theme.spacingS + 2),
              decoration: BoxDecoration(
                color: widget.isFilled ? widget.color : Colors.transparent,
                borderRadius: BorderRadius.circular(theme.radiusFull),
                border: widget.isFilled
                    ? null
                    : Border.all(color: widget.color.withValues(alpha: 0.5)),
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: theme.labelMedium.copyWith(
                    color: widget.isFilled ? Colors.white : widget.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  final Color color;

  _MapPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid pattern to simulate map
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some "roads"
    final roadPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(size.width * 0.3, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EventData {
  final String id;
  final String title;
  final String location;
  final String time;
  final String type;
  final String emoji;

  const EventData({
    required this.id,
    required this.title,
    required this.location,
    required this.time,
    this.type = 'Meetup',
    this.emoji = '☕',
  });
}
