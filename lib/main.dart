import 'dart:ui' as ui;
import 'dart:math';
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
    ImageAssetShape('images/bubble2.png'),
    ImageAssetShape('images/bubble3.png'),
    ImageAssetShape('images/bubble4.png'),
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
            // for  (var i = 0; i <1; i++)
            // for  (var i = 0; i < _imageAssets.length; i++)
              RelativisticEffectConfiguration(
              gravity: Gravity(0.0,0.5),
              particleCount: 50,
              maxVelocity: Velocity.custom(0.6),
              minVelocity: Velocity.custom(0.6),
              minRestitution: Restitution.bouncyCastle,
              emitCurve: Curves.linear,
              particlesPerEmit: 1,
                origin: Offset.zero, //comment for image
                maxOriginOffset: const Offset(1, 0), //comment for image
              // maxOriginOffset: const Offset(0.2, 0.01), //comment for round
              emitDuration: const Duration(seconds: 1),
              maxAngle: 90,
              minAngle: -100,
              maxParticleLifespan: const Duration(hours: 3),
              minFadeOutThreshold: 0.6,
              maxFadeOutThreshold: 0.8,
              minBeginScale: 0.7,
              maxBeginScale: 0.9,
              minEndScale: 1,
              maxEndScale: 1.2,
              particleConfiguration: ParticleConfiguration(
                shape: CircleShape(), //comment for image
                color: SingleParticleColor(color: Color(0xffF4B4FF)), //comment for image
                // shape: _imageAssets[0], //comment for round
                size: Size.square(width/5),
              ),
                // startDelay: Duration(milliseconds: i * 3000),
              // origin: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
