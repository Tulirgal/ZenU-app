import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';

class BubbleScreen extends StatelessWidget {
  const BubbleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'bubble',
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ZenTokens.zenFg),
                    onPressed: () => context.go('/dashboard'),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🫧', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 24),
                        Text(
                          'Bubble Canvas',
                          style: GoogleFonts.lora(
                            fontSize: 32,
                            color: ZenTokens.zenFg,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "We're crafting this experience 🌙",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: ZenTokens.zenFgMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: ZenTokens.zenSurface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: ZenTokens.zenBorderSoft),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Text(
                            "This module is being perfected for the app. Access it on the web version at your deployed URL.",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: ZenTokens.zenFg,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
