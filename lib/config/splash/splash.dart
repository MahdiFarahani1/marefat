import 'dart:async';

import 'package:bookapp/features/mainWrapper/view/navigaion.dart';
import 'package:bookapp/gen/assets.gen.dart';
import 'package:bookapp/shared/utils/esay_size.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainWrapper()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: EsaySize.width(context),
        height: EsaySize.height(context),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            Assets.images.bgSp.path,
          ),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.images.logoSp.image(
                    width: EsaySize.width(context) * 0.8,
                    height: EsaySize.height(context) * 0.8),
                const SizedBox(height: 22),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
