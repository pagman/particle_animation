import 'package:flutter/material.dart' hide Velocity;
import 'package:newton_particles/newton_particles.dart';

void main() {
  runApp(const NewtonExampleApp());
}

class NewtonExampleApp extends StatelessWidget {
  const NewtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.dark),
        canvasColor: const Color(0xff1b1b1d),
      ),
      home: Newton(
        effectConfigurations: [
          // Emulate light balls falling
          RelativisticEffectConfiguration(
            gravity: Gravity.zero,
            origin: Offset.zero,
            maxOriginOffset: const Offset(1, 0),
            maxAngle: 90,
            maxEndScale: 1,
            emitDuration: const Duration(milliseconds: 1000),
            maxVelocity: Velocity.custom(1.05),
            minVelocity: Velocity.custom(1),
            maxFadeOutThreshold: 1,
            maxParticleLifespan: const Duration(minutes: 1),
            minAngle: 90,
            minEndScale: 1,
            minFadeOutThreshold: 1,
            particleCount: 50,
            particlesPerEmit: 1,
            minParticleLifespan: const Duration(minutes: 1),
            particleConfiguration: const ParticleConfiguration(
              shape: CircleShape(),
              size: Size(60, 60),
            ),
          ),
        ],
      ),
    );
  }
}