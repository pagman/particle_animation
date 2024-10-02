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
    const primaryColor = <int, Color>{
      50: Color.fromRGBO(27, 27, 29, .1),
      100: Color.fromRGBO(27, 27, 29, .2),
      200: Color.fromRGBO(27, 27, 29, .3),
      300: Color.fromRGBO(27, 27, 29, .4),
      400: Color.fromRGBO(27, 27, 29, .5),
      500: Color.fromRGBO(27, 27, 29, .6),
      600: Color.fromRGBO(27, 27, 29, .7),
      700: Color.fromRGBO(27, 27, 29, .8),
      800: Color.fromRGBO(27, 27, 29, .9),
      900: Color.fromRGBO(27, 27, 29, 1),
    };

    final width = MediaQuery
        .of(context)
        .size
        .width;
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const MaterialColor(
          0x1b1b1d,
          primaryColor,
        ),
        canvasColor: const Color(0xff1b1b1d),
      ),
      home: Center(
        child: Newton(
          key: _newtonKey,
          effectConfigurations: [
          // Emulate light balls falling
            RelativisticEffectConfiguration(
              gravity: Gravity.zero,
          particleCount: 20,
          particlesPerEmit: 1,
              // origin: Offset.zero,
              origin: const Offset(0.5, 0.01),
              // maxOriginOffset: const Offset(1, 0),
          // distanceCurve: Curves.slowMiddle,
          // emitCurve: Curves.fastOutSlowIn,
          // fadeInCurve: Curves.easeIn,
          // fadeOutCurve: Curves.easeOut,
          emitDuration: const Duration(milliseconds: 250),
          // minAngle: 90,
          maxAngle: 90,
          // minDistance: 90,
          // maxDistance: 220,
          maxParticleLifespan: const Duration(hours: 3),
          minFadeOutThreshold: 0.6,
          maxFadeOutThreshold: 0.8,
          minBeginScale: 0.7,
          maxBeginScale: 0.9,
          minEndScale: 1,
          maxEndScale: 1.2,
          particleConfiguration: ParticleConfiguration(
            shape: _imageAssets[0],
            size: Size.square(50),
          ),
          startDelay: Duration.zero,
          // origin: const Offset(0, 1),
        ),
        ],
            ),
      ),);
  }
}