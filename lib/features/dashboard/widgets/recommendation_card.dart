import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../../core/theme/app_theme.dart'; 
 
class RecommendationCard extends StatelessWidget { 
  const RecommendationCard({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), 
      decoration: BoxDecoration( 
        color: ZenTokens.surface, 
        borderRadius: BorderRadius.circular(ZenTokens.radius2xl), 
        border: Border.all(color: ZenTokens.borderSoft.withValues(alpha: 0.55)), 
        boxShadow: [ 
          BoxShadow( 
            color: const Color(0xFF1E295A).withValues(alpha: 0.12), 
            blurRadius: 28, 
            offset: const Offset(0, 8), 
            spreadRadius: -18, 
          ) 
        ], 
      ), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [ 
          Text( 
            'For you right now'.toUpperCase(), 
            style: GoogleFonts.inter( 
              fontSize: 12, 
              fontWeight: FontWeight.w600, 
              letterSpacing: 1.2, 
              color: ZenTokens.secondary, 
            ), 
          ), 
          const SizedBox(height: 16), 
          _buildPrimaryCard(context), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildPrimaryCard(BuildContext context) { 
    return Container( 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration( 
        color: ZenTokens.surfaceRaised, 
        borderRadius: BorderRadius.circular(ZenTokens.radiusXl), 
        border: Border.all(color: ZenTokens.primary.withValues(alpha: 0.2)), 
        boxShadow: [ 
          BoxShadow( 
            color: ZenTokens.primary.withValues(alpha: 0.05), 
            blurRadius: 8, 
            offset: const Offset(0, 4), 
          ) 
        ], 
      ), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [ 
          Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [ 
              Container( 
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), 
                decoration: BoxDecoration( 
                  color: ZenTokens.primary.withValues(alpha: 0.1), 
                  borderRadius: BorderRadius.circular(ZenTokens.radiusFull), 
                ), 
                child: Text( 
                  '✨ Top pick'.toUpperCase(), 
                  style: GoogleFonts.inter( 
                    fontSize: 11.2, 
                    fontWeight: FontWeight.w600, 
                    letterSpacing: 0.5, 
                    color: ZenTokens.primary, 
                  ), 
                ), 
              ), 
              Text( 
                '3 min', 
                style: GoogleFonts.inter( 
                  fontSize: 12, 
                  color: ZenTokens.fgSubtle, 
                ), 
              ), 
            ], 
          ), 
          const SizedBox(height: 8), 
          Text( 
            'Box Breathing', 
            style: GoogleFonts.inter( 
              fontSize: 16, 
              fontWeight: FontWeight.w600, 
              color: ZenTokens.fg, 
              height: 1.2, 
            ), 
          ), 
          const SizedBox(height: 4), 
          Text( 
            'Clear your mind and find your center with this simple technique.', 
            maxLines: 2, 
            overflow: TextOverflow.ellipsis, 
            style: GoogleFonts.inter( 
              fontSize: 13, 
              color: ZenTokens.fgMuted, 
              height: 1.4, 
            ), 
          ), 
          const SizedBox(height: 12), 
          Row( 
            children: [ 
              _buildTag('Focus'), 
              const SizedBox(width: 4), 
              _buildTag('Calm'), 
            ], 
          ), 
          const SizedBox(height: 12), 
          GestureDetector( 
            onTap: () => context.go('/breathing'), 
            behavior: HitTestBehavior.opaque, 
            child: Container( 
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), 
              decoration: BoxDecoration( 
                color: ZenTokens.primary, 
                borderRadius: BorderRadius.circular(ZenTokens.radiusXl), 
              ), 
              child: Row( 
                mainAxisSize: MainAxisSize.min, 
                children: [ 
                  Text( 
                    'Start', 
                    style: GoogleFonts.inter( 
                      fontSize: 13, 
                      fontWeight: FontWeight.w500, 
                      color: Colors.white, 
                    ), 
                  ), 
                  const SizedBox(width: 6), 
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14), 
                ], 
              ), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildTag(String text) { 
    return Container( 
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), 
      decoration: BoxDecoration( 
        color: ZenTokens.surface, 
        border: Border.all(color: ZenTokens.borderSoft.withValues(alpha: 0.4)), 
        borderRadius: BorderRadius.circular(ZenTokens.radiusFull), 
      ), 
      child: Text( 
        text, 
        style: GoogleFonts.inter( 
          fontSize: 11.2, 
          color: ZenTokens.fgSubtle, 
        ), 
      ), 
    ); 
  } 
}
