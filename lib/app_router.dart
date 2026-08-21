import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:provider/provider.dart'; 
import 'core/auth/auth_service.dart'; 
import 'shared/widgets/splash_screen.dart'; 
import 'shared/widgets/sign_in_screen.dart'; 
import 'shared/widgets/sign_up_screen.dart'; 
import 'features/dashboard/dashboard_screen.dart'; 
import 'features/breathing/breathing_screen.dart'; 
import 'features/mindfulness/mindfulness_screen.dart'; 
import 'features/gratitude/gratitude_screen.dart'; 
import 'features/diary/diary_screen.dart'; 
import 'features/chat/chat_screen.dart'; 
import 'features/burst/burst_screen.dart'; 
import 'features/bubble/bubble_screen.dart'; 
import 'features/scribble/scribble_screen.dart'; 
import 'features/doodle/doodle_screen.dart'; 
import 'features/healing_garden/healing_garden_screen.dart'; 
import 'features/inner_compass/inner_compass_screen.dart'; 
import 'features/pss/pss_screen.dart'; 
 
class AppRouter { 
  static GoRouter router(BuildContext context) => GoRouter( 
    initialLocation: '/splash', 
    refreshListenable: context.read<AuthService>(),
    redirect: (ctx, state) { 
      final auth   = ctx.read<AuthService>(); 
      final loc    = state.matchedLocation; 
      final isAuth = auth.isAuthenticated; 
 
      if (!auth.initialized) return '/splash'; 
      if (loc == '/splash') return isAuth ? '/dashboard' : '/signin'; 
      if (!isAuth && loc != '/signin' && loc != '/signup') return '/signin'; 
      if (isAuth && (loc == '/signin' || loc == '/signup')) return '/dashboard'; 
      return null; 
    }, 
    routes: [ 
      GoRoute(path: '/splash',         builder: (context, state) => const SplashScreen()), 
      GoRoute(path: '/signin',         builder: (context, state) => const SignInScreen()), 
      GoRoute(path: '/signup',         builder: (context, state) => const SignUpScreen()), 
      GoRoute(path: '/dashboard',      builder: (context, state) => const DashboardScreen()), 
      GoRoute(path: '/breathing',      builder: (context, state) => const BreathingScreen()), 
      GoRoute(path: '/mindfulness',    builder: (context, state) => const MindfulnessScreen()), 
      GoRoute(path: '/gratitude',      builder: (context, state) => const GratitudeScreen()), 
      GoRoute(path: '/diary',          builder: (context, state) => const DiaryScreen()), 
      GoRoute(path: '/chat',           builder: (context, state) => const ChatScreen()), 
      GoRoute(path: '/burst',          builder: (context, state) => const BurstScreen()), 
      GoRoute(path: '/bubble',         builder: (context, state) => const BubbleScreen()), 
      GoRoute(path: '/scribble',       builder: (context, state) => const ScribbleScreen()), 
      GoRoute(path: '/doodle',         builder: (context, state) => const DoodleScreen()), 
      GoRoute(path: '/healing-garden', builder: (context, state) => const HealingGardenScreen()), 
      GoRoute(path: '/inner-compass',  builder: (context, state) => const InnerCompassScreen()), 
      GoRoute(path: '/pss',            builder: (context, state) => const PSSScreen()), 
    ], 
  ); 
}
