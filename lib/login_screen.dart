import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_responsive_login_ui/pallete.dart';
import 'package:flutter_responsive_login_ui/widgets/gradient_button.dart';
import 'package:flutter_responsive_login_ui/widgets/login_field.dart';
import 'package:flutter_responsive_login_ui/widgets/social_button.dart';

class AuthBackground extends StatefulWidget {
  const AuthBackground({super.key});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with TickerProviderStateMixin {
  bool _initialized = false;

  final _random = Random();
  final List<_Sphere> _spheres = [];

  @override
  void dispose() {
    for (var sphere in _spheres) {
      sphere.controller.dispose();
    }
    super.dispose();
  }

  void _generateSpheres(int count, Size screenSize) {
    _spheres.clear();

    for (int i = 0; i < count; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 10 + _random.nextInt(10)),
      )..repeat(reverse: true);

      final begin = Offset(
        _random.nextDouble() * 1.5 - 0.5,
        _random.nextDouble() * 1.5 - 0.5,
      );
      final end = Offset(
        _random.nextDouble() * 1.5 - 0.5,
        _random.nextDouble() * 1.5 - 0.5,
      );

      final animation = Tween<Offset>(begin: begin, end: end).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );

      final size = 50.0 + _random.nextDouble() * 150; // 50 to 200

      _spheres.add(_Sphere(
        animation: animation,
        controller: controller,
        size: size,
      ));
    }
  }

  Widget _build3DCircle(double size, double screenWidth) {
    final double blurRadius = screenWidth < 600 ? 8 : screenWidth < 1024 ? 30 : 50;
    final double spreadRadius = screenWidth < 600 ? 2 : screenWidth < 1024 ? 6 : 10;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(0.8, -0.8),
          radius: 1,
          colors: [
            Pallete.gradient1,
            Pallete.gradient2,
            Pallete.gradient3,
          ],
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Pallete.gradient2.withOpacity(0.3),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final width = screenSize.width;

    int sphereCount = width < 600
        ? 8
        : width < 1024
            ? 12
            : 20;

    // only generate once
    if (!_initialized) {
      _generateSpheres(sphereCount, screenSize);
      _initialized = true;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Floating orbs
          for (final sphere in _spheres)
            AnimatedBuilder(
              animation: sphere.animation,
              builder: (_, __) {
                final offset = sphere.animation.value;
                return Positioned(
                  left: screenSize.width * offset.dx,
                  top: screenSize.height * offset.dy,
                  child: _build3DCircle(sphere.size, screenSize.width),
                );
              },
            ),

          // Auth UI
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: const [
                    Text(
                      'Sign In.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    SizedBox(height: 50),
                    SocialButton(
                      iconPath: 'assets/svgs/g_logo.svg',
                      label: 'Continue with Google',
                    ),
                    SizedBox(height: 20),
                    SocialButton(
                      iconPath: 'assets/svgs/f_logo.svg',
                      label: 'Continue with Facebook',
                      horizontalPadding: 90,
                    ),
                    SizedBox(height: 15),
                    Text('or', style: TextStyle(fontSize: 17)),
                    SizedBox(height: 15),
                    LoginField(hintText: 'Email'),
                    SizedBox(height: 15),
                    LoginField(hintText: 'Password'),
                    SizedBox(height: 20),
                    GradientButton(),
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

class _Sphere {
  final Animation<Offset> animation;
  final AnimationController controller;
  final double size;

  _Sphere({
    required this.animation,
    required this.controller,
    required this.size,
  });
}
