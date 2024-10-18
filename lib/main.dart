import 'package:flutter/material.dart' hide Velocity;
import 'package:flutter/services.dart';
import 'package:newton_particles/newton_particles.dart';
import 'dart:ui' as ui;

void main() {
  runApp(const ThumbUpExampleApp());
}

class ThumbUpExampleApp extends StatelessWidget {
  const ThumbUpExampleApp({super.key});

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const MaterialColor(
          0x1b1b1d,
          primaryColor,
        ),
        canvasColor: const Color(0xff1b1b1d),
      ),
      home: const ThumbUpExample(),
    );
  }
}

class ThumbUpExample extends StatefulWidget {
  const ThumbUpExample({super.key});

  @override
  State<ThumbUpExample> createState() => _ThumbUpExampleState();
}

class _ThumbUpExampleState extends State<ThumbUpExample> {
  final _newtonKey = GlobalKey<NewtonState>();
  ui.Image? myImage;

  @override
  void initState() {
    super.initState();
    _createImage();
  }

  Future<void> _createImage() async {
    // Load image as byte data
    final ByteData data = await rootBundle.load('images/bubble6.png');

    // Convert ByteData to Uint8List
    final Uint8List bytes = data.buffer.asUint8List();

    // Decode image bytes into ui.Image
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();

    // Set the loaded image into the state
    setState(() {
      myImage = frame.image;
    });
  }

  final List<ImageAssetShape> _imageAssets = [
    ImageAssetShape('images/thumb_up_1.png'),
    ImageAssetShape('images/thumb_up_2.png'),
    ImageAssetShape('images/thumb_up_3.png'),
  ];
  final _emojiSize = 50.0;
  final _btnSize = 50.0;
  int _emit = 1;
  int _duration = 1000000000000;
  bool isPaused = false; // Track if the animation is paused
 // real physics with image as particle
  RelativisticEffectConfiguration currentActiveEffectConfiguration1(
      int count, Duration delay, double width, int particlesPerRow) {
    return RelativisticEffectConfiguration(
      gravity: Gravity(0.0, 0.3),
      particleCount: count.toInt(),
      maxVelocity: Velocity.custom(0.6),
      minVelocity: Velocity.custom(0.6),
      minRestitution: Restitution.superBall,
      emitCurve: Curves.linear,
      particlesPerEmit: _emit,
      // origin: const Offset(0.5, 0), //comment for image
      origin: const Offset(0.5, 0.01),
      emitDuration: delay,
      maxAngle: 180,
      minAngle: -180,
      maxParticleLifespan: const Duration(hours: 3),
      minFadeOutThreshold: 0.6,
      maxFadeOutThreshold: 0.8,
      // minBeginScale: 0.6,
      // maxBeginScale: 1.4,
      // minEndScale: 0.6,
      // maxEndScale: 1.4,
      particleConfiguration: ParticleConfiguration(
        shape: ImageShape(myImage!),
        //comment for image
        // color: const SingleParticleColor(color: Color(0xffF4B4FF)), //comment for image
        size: Size(width / particlesPerRow, width / particlesPerRow),
      ),
    );
  }
 // real physics with balls as particles
  RelativisticEffectConfiguration currentActiveEffectConfiguration2(
      int count, Duration delay, double width, int particlesPerRow) {
    return RelativisticEffectConfiguration(
      gravity: Gravity(0.0, 0.2),
      particleCount: count.toInt(),
      maxVelocity: Velocity.custom(0.6),
      minVelocity: Velocity.custom(0.1),
      minRestitution: Restitution.superBall,
      // emitCurve: Curves.linear,
      particlesPerEmit: _emit,
      origin:  Offset(0.5, 0),
      //comment for image
      // origin: const Offset(0.5, 0.01),
      emitDuration: delay,
      maxAngle: 180,
      minAngle: -180,
      maxParticleLifespan: const Duration(hours: 3),
      minFadeOutThreshold: 0.6,
      maxFadeOutThreshold: 0.8,
      minBeginScale: 0.6,
      maxBeginScale: 1.4,
      minEndScale: 0.6,
      maxEndScale: 1.4,
      fadeInCurve: Curves.easeIn,
      particleConfiguration: ParticleConfiguration(
        shape: CircleShape(),
        //comment for image
        color: const SingleParticleColor(color: Color(0xffF4B4FF)),
        //comment for image
        size: Size(width / particlesPerRow, width / particlesPerRow),
      ),
    );
  }
 //explosion effect
  DeterministicEffectConfiguration currentActiveEffectConfigurationExplode(
      int index, Duration delay, double width, int particlesPerRow) {
    return DeterministicEffectConfiguration(
      particleCount: 300,
      particlesPerEmit: 100,
      distanceCurve: Curves.slowMiddle,
      emitCurve: Curves.fastOutSlowIn,
      fadeInCurve: Curves.easeIn,
      fadeOutCurve: Curves.easeOut,
      emitDuration: const Duration(milliseconds: 500),
      minAngle: -180,
      maxAngle: 180,
      minDistance: 120,
      maxDistance: 320,
      maxParticleLifespan: const Duration(seconds: 5),
      minFadeOutThreshold: 0.6,
      maxFadeOutThreshold: 0.8,
      minBeginScale: 0.7,
      maxBeginScale: 0.9,
      minEndScale: 1,
      maxEndScale: 1.2,
      particleConfiguration: ParticleConfiguration(
        shape: CircleShape(),
        //comment for image
        color: const SingleParticleColor(color: Color(0xffF4B4FF)),
        //comment for image
        size: Size(width / particlesPerRow, width / particlesPerRow),
      ),
      startDelay: delay,
      origin: const Offset(0.5, 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    int particlesPerRow = 7;
    double width = MediaQuery.of(context).size.width;
    int count = 15;
    return Scaffold(
      backgroundColor: Color(0xff3A3A3A),
      body: Stack(
        children: <Widget>[
          Newton(
            key: _newtonKey,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: _btnSize,
                  height: _btnSize,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _emit = 1;
                        isPaused = false; // Resuming, so not paused anymore
                      });
                      //image as particles
                      _newtonKey.currentState?.addEffect(currentActiveEffectConfiguration1(50, const Duration(seconds: 1), width, particlesPerRow));
                      //balls as particles
                      // _newtonKey.currentState?.addEffect(currentActiveEffectConfiguration2(50,const Duration(seconds: 1),width,particlesPerRow));
                    },
                    child: Container(
                      width: _btnSize,
                      height: _btnSize,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(_btnSize / 2),
                      ),
                      child: const Center(child: Text('Start')),
                    ),
                  ),
                ),
                SizedBox(
                  width: _btnSize,
                  height: _btnSize,
                  child: GestureDetector(
                    onTap: () {
                      if (!isPaused) {
                        setState(() {
                          isPaused = true;
                        });
                        _newtonKey.currentState
                            ?.clearEffects(); // Stop emitting new particles
                      }
                    },
                    child: Container(
                      width: _btnSize,
                      height: _btnSize,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(_btnSize / 2),
                      ),
                      child: const Center(child: Text('Pause')),
                    ),
                  ),
                ),
                SizedBox(
                  width: _btnSize,
                  height: _btnSize,
                  child: GestureDetector(
                    onTap: () {
                      if (!isPaused) {
                        setState(() {
                          isPaused = true;
                        });
                        _newtonKey.currentState
                            ?.clearEffects(); // Stop emitting new particles
                      }

                      _newtonKey.currentState?.addEffect(
                          currentActiveEffectConfigurationExplode(
                              0, Duration(milliseconds: 1 * 2000), width, 15));
                    },
                    child: Container(
                      width: _btnSize,
                      height: _btnSize,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(_btnSize / 2),
                      ),
                      child: const Center(child: Text('Stop')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
