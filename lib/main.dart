import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

void main() {
  runApp(const NewtonExampleApp());
}

class NewtonExampleApp extends StatefulWidget {
  const NewtonExampleApp({super.key});

  @override
  State<NewtonExampleApp> createState() => _NewtonExampleAppState();
}

class _NewtonExampleAppState extends State<NewtonExampleApp> {
  final _newtonKey = GlobalKey<NewtonState>();
  final List<ImageAssetShape> _imageAssets = [
    ImageAssetShape('images/bubble.png'),
    ImageAssetShape('images/thumb_up_1.png'),
    ImageAssetShape('images/thumb_up_1.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff3A3A3A),
        body:
        Newton(
          key: _newtonKey,
          effectConfigurations: [
            // Emulate light balls falling
            for  (var i = 0; i < _imageAssets.length; i++)
              RelativisticEffectConfiguration(
              gravity: Gravity.zero,
              particleCount: 1,
              maxVelocity: Velocity.snail,
              emitCurve: Curves.decelerate,
              particlesPerEmit: 1,
              origin: const Offset(0.5, 0.01),
              emitDuration: const Duration(seconds: 2),
              maxAngle: 90,
              maxParticleLifespan: const Duration(hours: 3),
              minFadeOutThreshold: 0.6,
              maxFadeOutThreshold: 0.8,
              minBeginScale: 0.7,
              maxBeginScale: 0.9,
              minEndScale: 1,
              maxEndScale: 1.2,
              particleConfiguration: ParticleConfiguration(
                shape: _imageAssets[i],
                size: Size(width / 5, width / 5),
              ),
                startDelay: Duration(milliseconds: i * 5000),
              // origin: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
