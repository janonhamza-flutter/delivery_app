import 'dart:math' as math;

import 'package:delivery_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key, this.duration = const Duration(seconds: 7)});

  final Duration duration;

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ringController;

  static final Color _accentSoft = Color.lerp(
    AppColors.secondary,
    Colors.white,
    0.4,
  )!;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ambient breathing glow behind the mark.
                    Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withOpacity(0.28),
                                blurRadius: 90,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scaleXY(
                          begin: 0.92,
                          end: 1.05,
                          // breathing uses a fraction of the overall duration for a natural feel
                          duration: (widget.duration.inMilliseconds * 0.55)
                              .round()
                              .ms,
                          curve: Curves.easeInOut,
                        ),

                    // Rotating sweep-gradient ring — the signature loading motif.
                    AnimatedBuilder(
                      animation: _ringController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _ringController.value * 2 * math.pi,
                          child: CustomPaint(
                            size: const Size(220, 220),
                            painter: _RingPainter(
                              accent: AppColors.secondary,
                              accentSoft: _accentSoft,
                            ),
                          ),
                        );
                      },
                    ),

                    // Core mark: circular image of the delivery truck.
                    SizedBox(
                          width: 180,
                          height: 180,
                          child: ClipOval(
                            child: Container(
                              color: AppColors.primary,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/delivery.png',
                                fit: BoxFit.contain,
                                width: 140,
                                height: 140,
                              ),
                            ),
                          ),
                        )
                        .animate(delay: 80.ms)
                        .slide(
                          begin: const Offset(-0.8, 0),
                          end: Offset.zero,
                          duration: 700.ms,
                          curve: Curves.easeOut,
                        )
                        .fade(duration: 700.ms),
                  ],
                ),
              )
              .animate()
              .fade(duration: 500.ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),

          const SizedBox(height: 22),

          Text(
                AppStrings.appName,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: AppTextStyles.splashTitle,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              )
              .animate(delay: 150.ms)
              .fade(duration: 600.ms)
              .slideY(begin: 0.12, end: 0),

          const SizedBox(height: 6),

          Text(
            AppStrings.appName.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: AppColors.white.withOpacity(0.55),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
            ),
          ).animate(delay: 260.ms).fade(duration: 600.ms),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.accent, required this.accentSoft});

  final Color accent;
  final Color accentSoft;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 4;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.white.withOpacity(0.08);
    canvas.drawCircle(center, radius, trackPaint);

    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [Colors.transparent, accent, accentSoft, Colors.transparent],
        stops: const [0.0, 0.15, 0.35, 0.5],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 2 * 0.5,
      false,
      sweepPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.accent != accent || oldDelegate.accentSoft != accentSoft;
}
