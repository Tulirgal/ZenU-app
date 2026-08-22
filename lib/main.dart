import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/auth/auth_service.dart';
import 'core/theme/zen_tokens.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  final authService = AuthService()..initialize();
  AppRouter.init(authService);
  
  runApp(ChangeNotifierProvider.value(
    value: authService,
    child: const ZenUApp(),
  ));
}

class ZenUApp extends StatelessWidget {
  const ZenUApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ZenU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      routerConfig: AppRouter.router,
    );
  }
}
