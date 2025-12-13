/// Friend Request Card Widget
///
/// Ticket-style card for pending friend requests.
/// Features dashed perforation separating user info from actions.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme_provider.dart';

class FriendRequestCard extends StatefulWidget {
  final FriendRequestData request;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const FriendRequestCard({
    super.key,
    required this.request,
    this.onAccept,
    this.onDecline,
  });

  @override
  State<FriendRequestCard> createState() => _FriendRequestCardState();
}

class _FriendRequestCardState extends State<FriendRequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _triggerBounce() {
    _bounceController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;
    final request = widget.request;

    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
              color: theme.backgroundLight,
              borderRadius: BorderRadius.circular(theme.radiusLarge),
              border: Border.all(
                color: theme.mutedPrimary.withValues(alpha: 0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryAccent.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left side - User info
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(theme.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Super-ellipse avatar
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.secondaryAccent.withValues(
                                alpha: 0.3,
                              ),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              request.avatarUrl,
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
                        Text(
                          request.name,
                          style: theme.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          request.major,
                          style: theme.bodySmall.copyWith(
                            color: theme.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: theme.spacingXS),
                        if (request.mutualConnection != null)
                          Row(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 12,
                                color: theme.secondaryAccent,
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  request.mutualConnection!,
                                  style: theme.bodySmall.copyWith(
                                    color: theme.secondaryAccent,
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                // Dashed perforation
                _DashedLine(height: 140, color: theme.mutedSecondary),
                // Right side - Actions
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacingM,
                    vertical: theme.spacingM,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ActionCircle(
                        icon: Icons.check,
                        color: theme.secondaryAccent,
                        isFilled: true,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          _triggerBounce();
                          widget.onAccept?.call();
                        },
                      ),
                      SizedBox(height: theme.spacingS),
                      _ActionCircle(
                        icon: Icons.close,
                        color: theme.primaryAccent,
                        isFilled: false,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onDecline?.call();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashedLine extends StatelessWidget {
  final double height;
  final Color color;

  const _DashedLine({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(painter: _DashedLinePainter(color: color)),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    const dashHeight = 6.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActionCircle extends StatefulWidget {
  final IconData icon;
  final Color color;
  final bool isFilled;
  final VoidCallback? onTap;

  const _ActionCircle({
    required this.icon,
    required this.color,
    this.isFilled = false,
    this.onTap,
  });

  @override
  State<_ActionCircle> createState() => _ActionCircleState();
}

class _ActionCircleState extends State<_ActionCircle>
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
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.isFilled ? widget.color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: widget.color, width: 2),
              ),
              child: Icon(
                widget.icon,
                color: widget.isFilled ? Colors.white : widget.color,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}

class FriendRequestData {
  final String id;
  final String name;
  final String avatarUrl;
  final String major;
  final String? mutualConnection;

  const FriendRequestData({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.major,
    this.mutualConnection,
  });
}
