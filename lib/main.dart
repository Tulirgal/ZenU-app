import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart'; 
import 'package:provider/provider.dart'; 
import 'package:hive_flutter/hive_flutter.dart'; 
import 'core/auth/auth_service.dart'; 
import 'core/theme/app_theme.dart'; 
import 'app_router.dart'; 
 
void main() async { 
  WidgetsFlutterBinding.ensureInitialized(); 
  await Hive.initFlutter(); 
 
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle( 
    statusBarColor: Colors.transparent, 
    statusBarIconBrightness: Brightness.light, 
  )); 
  SystemChrome.setPreferredOrientations([ 
    DeviceOrientation.portraitUp, 
    DeviceOrientation.portraitDown, 
  ]); 
 
  runApp( 
    ChangeNotifierProvider( 
      create: (_) => AuthService()..initialize(), 
      child: const ZenUApp(), 
    ), 
  ); 
} 
 
class ZenUApp extends StatelessWidget { 
  const ZenUApp({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp.router( 
      title: 'ZenU', 
      debugShowCheckedModeBanner: false, 
      theme: AppTheme.theme, 
      routerConfig: AppRouter.router(context), 
    ); 
  } 
}
