import 'package:flutter/material.dart';
import '../widgets/glass_box.dart';
import 'home_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark background for contrast
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
                        color: Colors.deepPurple.withValues(alpha: 0.4),
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
                        color: Colors.blueAccent.withValues(alpha: 0.4),
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
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hello Again!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome back, you\'ve been missed!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Email TextField
                    const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Password TextField
                    const TextField(
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Signup Button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const HomeScreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  // Fade Transition
                                  var fadeAnimation =
                                      Tween(begin: 0.0, end: 1.0).animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOut,
                                        ),
                                      );

                                  return FadeTransition(
                                    opacity: fadeAnimation,
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 800,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurpleAccent.withValues(
                                alpha: 0.5,
                              ),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
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
