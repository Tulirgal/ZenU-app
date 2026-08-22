import 'package:flutter/material.dart';
import '../../core/theme/zen_tokens.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ZenTokens.zenPrimary.withValues(alpha: 0.1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.self_improvement_rounded,
                  color: ZenTokens.zenPrimary,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: ZenTokens.s6),
            Text(
              'ZenU',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: ZenTokens.zenPrimary,
              ),
            ),
            const SizedBox(height: ZenTokens.s2),
            Text(
              'Your Student Wellness Companion',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ZenTokens.zenFgMuted,
              ),
            ),
            const SizedBox(height: ZenTokens.s10),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(ZenTokens.zenPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
