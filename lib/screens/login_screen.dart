/// Login Screen
///
/// Animated login screen with glassmorphism design.
/// Navigates to Welcome Screen on sign up.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/glass_box.dart';
import '../widgets/responsive_button.dart';
import '../theme/theme_provider.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
    ]).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToWelcome() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const WelcomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // iOS-like fade with slight scale
          var fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(scale: scaleAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.cuTheme;

    return Scaffold(
      backgroundColor: theme.backgroundLight,
      body: Stack(
        children: [
          // Animated Background Circles
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                children: [
                  Align(
                    alignment: _topAlignmentAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.primaryAccent.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  Align(
                    alignment: _bottomAlignmentAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.secondaryAccent.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Glassmorphism Login Card
          Center(
            child: GlassBox(
              width: 350,
              height: 450,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello Again!',
                      style: theme.heading1.copyWith(
                        fontSize: 28,
                        color: theme.textPrimary,
                      ),
                    ),
                    SizedBox(height: theme.spacingS),
                    Text(
                      'Welcome back, you\'ve been missed!',
                      style: theme.bodyMedium.copyWith(
                        color: theme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: theme.spacingXL),

                    // Email TextField
                    TextField(
                      style: TextStyle(color: theme.textPrimary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.mutedPrimary.withValues(alpha: 0.5),
                        hintText: 'Email',
                        hintStyle: TextStyle(color: theme.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            theme.radiusMedium,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: theme.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(height: theme.spacingM),

                    // Password TextField
                    TextField(
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(color: theme.textPrimary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.mutedPrimary.withValues(alpha: 0.5),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: theme.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            theme.radiusMedium,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: theme.textSecondary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: theme.textSecondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: theme.spacingXL + theme.spacingS),

                    // Signup Button
                    SizedBox(
                      width: double.infinity,
                      child: ResponsiveButton(
                        onTap: _navigateToWelcome,
                        backgroundColor: theme.primaryAccent,
                        borderRadius: BorderRadius.circular(theme.radiusMedium),
                        padding: EdgeInsets.all(theme.spacingM),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryAccent.withValues(alpha: 0.5),
                            spreadRadius: 1,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: theme.labelMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
