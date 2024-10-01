import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ParticleFallAnimation(),
      ),
    );
  }
}
 // changes
class ParticleFallAnimation extends StatefulWidget {
  @override
  _ParticleFallAnimationState createState() => _ParticleFallAnimationState();
}

class _ParticleFallAnimationState extends State<ParticleFallAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers = [];
  late List<Animation<double>> _animations = [];
  late List<Offset> _particlePositions = [];
  late List<Offset> _explosionDirections = [];

  final int numberOfParticles = 5; // Number of particles in each layer
  final double particleRadius = 60.0; // Radius of the particles
  int numberOfLayers = 0; // Will be calculated based on screen height

  final int totalDuration = 60; // Total duration in seconds (1 minute)
  bool animationStopped = false;
  bool exploded = false;

  late AnimationController _explodeController;
  late Animation<double> _explodeAnimation;

  @override
  void initState() {
    super.initState();

    // Calculate number of layers based on screen height after layout is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenHeight = MediaQuery.of(context).size.height;
      setState(() {
        numberOfLayers = (screenHeight / (2 * particleRadius)).floor();
      });
      _initializeAnimation();
      _startAnimation();
    });

    // Initialize explosion animation controller
    _explodeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _explodeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _explodeController, curve: Curves.easeOut),
    );
  }

  void _initializeAnimation() {
    // Calculate how much time each particle should take to fall
    int totalParticles = numberOfParticles * numberOfLayers;
    double timePerParticle = totalDuration / totalParticles;

    // Initialize AnimationControllers and Animations for each particle
    for (int layer = 0; layer < numberOfLayers; layer++) {
      for (int i = 0; i < numberOfParticles; i++) {
        AnimationController controller = AnimationController(
          vsync: this,
          duration: Duration(seconds: timePerParticle.floor()), // Duration per particle fall
        );
        _controllers.add(controller);

        Animation<double> animation = Tween<double>(begin: -0.1, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOut,
          ),
        );
        _animations.add(animation);

        // Initialize all particle positions to start well above the screen
        _particlePositions.add(Offset(
            i * (MediaQuery.of(context).size.width*5 / numberOfParticles*5),
            particleRadius * 20 // Start much above the screen (e.g., -240 for a radius of 60)
        ));

        // Initialize random directions for explosion
        _explosionDirections.add(_getRandomDirection());
      }
    }
  }

  // Get a random explosion direction (vector) for each particle changes
  Offset _getRandomDirection() {
    final random = Random();
    double angle = random.nextDouble() * 2 * pi; // Random angle between 0 and 2*PI
    double distance = random.nextDouble() * 200 + 100; // Random explosion distance
    return Offset(cos(angle) * distance, sin(angle) * distance);
  }

  void _startAnimation() async {
    // Calculate how much time delay between each particle's fall
    int totalParticles = numberOfParticles * numberOfLayers;
    double timePerParticle = totalDuration / totalParticles;

    // Start animation layer by layer with delay for each particle
    for (int layer = 0; layer < numberOfLayers; layer++) {
      for (int i = 0; i < numberOfParticles; i++) {
        if (!animationStopped && !exploded) {
          int index = layer * numberOfParticles + i;
          await Future.delayed(Duration(milliseconds: (timePerParticle * 1000).floor()));
          _controllers[index].forward();
        }
      }
    }
  }

  void _stopAnimationAndExplode() {
    setState(() {
      animationStopped = true;
      exploded = true;

      // Stop all controllers and save the current particle positions
      for (int i = 0; i < _controllers.length; i++) {
        _controllers[i].stop();

        double x = i % numberOfParticles * (MediaQuery.of(context).size.width / numberOfParticles);
        double y = _animations[i].value * MediaQuery.of(context).size.height;
        _particlePositions[i] = Offset(x+200, y+200);
      }

      // Start the explosion effect
      _explodeController.forward();
    });
  }

  void _resumeAnimation() {
    setState(() {
      exploded = false;
      animationStopped = false;

      // Reset explosion controller
      _explodeController.reset();

      // Reset the particle positions to the saved state and restart animation
      for (int i = 0; i < _controllers.length; i++) {
        _controllers[i].reset();
      }

      // Start the falling animation again
      _startAnimation();
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    _explodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: exploded ? _explodeAnimation : Listenable.merge(_controllers),
          builder: (context, child) {
            return CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: ParticlePainter(
                _animations,
                _particlePositions,
                particleRadius,
                numberOfParticles,
                animationStopped,
                exploded,
                _explodeAnimation,
                _explosionDirections,
              ),
            );
          },
        ),
        // Control buttons for Explode and Resume
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _stopAnimationAndExplode,
                child: Text('Explode'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _resumeAnimation,
                child: Text('Resume'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Animation<double>> animations;
  final List<Offset> particlePositions;
  final double particleRadius;
  final int numberOfParticles;
  final bool animationStopped;
  final bool exploded;
  final Animation<double> explodeAnimation;
  final List<Offset> explosionDirections;

  ParticlePainter(
      this.animations,
      this.particlePositions,
      this.particleRadius,
      this.numberOfParticles,
      this.animationStopped,
      this.exploded,
      this.explodeAnimation,
      this.explosionDirections,
      );

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Paint borderPaint = Paint()
      ..color = Colors.red // Set the border color to red
      ..style = PaintingStyle.stroke // Set style to stroke for the border
      ..strokeWidth = 30; // Set the border width

    double spacing = size.width / numberOfParticles;
    int numberOfLayers = (animations.length / numberOfParticles).floor();

    // Draw each particle in all layers
    for (int layer = 0; layer < numberOfLayers; layer++) {
      for (int i = 0; i < numberOfParticles; i++) {
        int index = layer * numberOfParticles + i;

        double x, y;

        if (exploded) {
          // Explosion: Move the particles outward in random directions
          x = particlePositions[index].dx + explosionDirections[index].dx * explodeAnimation.value;
          y = particlePositions[index].dy + explosionDirections[index].dy * explodeAnimation.value;
        } else if (animationStopped) {
          // Animation stopped: Use saved positions
          x = particlePositions[index].dx;
          y = particlePositions[index].dy;
        } else {
          // During animation: Calculate position based on animation progress
          x = spacing * i + spacing / 2;
          y = (size.height - (layer + 1) * 2 * particleRadius + particleRadius + particleRadius + 30) * animations[index].value;
        }

        // Draw the border circle
        canvas.drawCircle(Offset(x, y - particleRadius), particleRadius, borderPaint);
        // Draw the filled particle
        canvas.drawCircle(Offset(x, y - particleRadius), particleRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
