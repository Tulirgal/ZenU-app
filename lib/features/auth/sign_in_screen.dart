import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:provider/provider.dart'; 
import '../../core/auth/auth_service.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class SignInScreen extends StatefulWidget { 
  const SignInScreen({super.key}); 
 
  @override 
  State<SignInScreen> createState() => _SignInScreenState(); 
} 
 
class _SignInScreenState extends State<SignInScreen> { 
  final _emailCtrl = TextEditingController(); 
  final _passwordCtrl = TextEditingController(); 
  String? _formError; 
  bool _isLoading = false; 
 
  @override 
  void dispose() { 
    _emailCtrl.dispose(); 
    _passwordCtrl.dispose(); 
    super.dispose(); 
  } 
 
  Future<void> _handleSignIn() async { 
    final email = _emailCtrl.text.trim(); 
    final password = _passwordCtrl.text.trim(); 
     
    if (email.isEmpty || password.isEmpty) { 
      setState(() => _formError = 'Please enter email and password.'); 
      return; 
    } 
     
    setState(() { 
      _formError = null; 
      _isLoading = true; 
    }); 
 
    final authService = context.read<AuthService>(); 
    final success = await authService.signIn(email, password); 
     
    if (!mounted) return; 
     
    setState(() => _isLoading = false); 
     
    if (success) { 
      context.go('/'); 
    } else { 
      setState(() => _formError = 'Sign-in failed. Please check your credentials and try again.'); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'home', 
        child: SafeArea( 
          child: Center( 
            child: SingleChildScrollView( 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48), 
              child: ConstrainedBox( 
                constraints: const BoxConstraints(maxWidth: 400), 
                child: Container( 
                  padding: const EdgeInsets.all(32), 
                  decoration: BoxDecoration( 
                    color: Colors.white.withValues(alpha: 0.7), 
                    borderRadius: BorderRadius.circular(32), 
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5), 
                    boxShadow: [ 
                      BoxShadow( 
                        color: Colors.black.withValues(alpha: 0.05), 
                        blurRadius: 24, 
                        offset: const Offset(0, 12), 
                      ), 
                    ], 
                  ), 
                  child: Column( 
                    mainAxisSize: MainAxisSize.min, 
                    children: [ 
                      Container( 
                        width: 48, 
                        height: 48, 
                        decoration: BoxDecoration( 
                          color: ZenTokens.primary.withValues(alpha: 0.15), 
                          shape: BoxShape.circle, 
                        ), 
                        child: Icon(Icons.login_rounded, color: ZenTokens.primary), 
                      ), 
                      const SizedBox(height: 16), 
                      Text( 
                        'Welcome back', 
                        style: GoogleFonts.lora(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87), 
                      ), 
                      const SizedBox(height: 8), 
                      Text( 
                        'Sign in to continue your ZenU journey.', 
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.black54), 
                      ), 
                      const SizedBox(height: 32), 
                       
                      if (_formError != null) ...[ 
                        Container( 
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
                          decoration: BoxDecoration( 
                            color: Colors.red.withValues(alpha: 0.1), 
                            borderRadius: BorderRadius.circular(12), 
                            border: Border.all(color: Colors.red.withValues(alpha: 0.2)), 
                          ), 
                          child: Text(_formError!, style: GoogleFonts.inter(fontSize: 13, color: Colors.red[700])), 
                        ), 
                        const SizedBox(height: 24), 
                      ], 
 
                      TextField( 
                        controller: _emailCtrl, 
                        keyboardType: TextInputType.emailAddress, 
                        decoration: InputDecoration( 
                          labelText: 'Email', 
                          hintText: 'you@example.com', 
                          labelStyle: GoogleFonts.inter(color: Colors.black54), 
                          filled: true, 
                          fillColor: Colors.white.withValues(alpha: 0.6), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), 
                        ), 
                      ), 
                      const SizedBox(height: 16), 
                       
                      TextField( 
                        controller: _passwordCtrl, 
                        obscureText: true, 
                        decoration: InputDecoration( 
                          labelText: 'Password', 
                          hintText: '••••••••', 
                          labelStyle: GoogleFonts.inter(color: Colors.black54), 
                          filled: true, 
                          fillColor: Colors.white.withValues(alpha: 0.6), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), 
                        ), 
                      ), 
                      const SizedBox(height: 12), 
                       
                      Align( 
                        alignment: Alignment.centerRight, 
                        child: TextButton( 
                          onPressed: () {}, 
                          style: TextButton.styleFrom(foregroundColor: ZenTokens.primary), 
                          child: Text('Forgot Password?', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)), 
                        ), 
                      ), 
                      const SizedBox(height: 12), 
                       
                      SizedBox( 
                        width: double.infinity, 
                        child: ElevatedButton( 
                          onPressed: _isLoading ? null : _handleSignIn, 
                          style: ElevatedButton.styleFrom( 
                            backgroundColor: ZenTokens.primary, 
                            foregroundColor: Colors.white, 
                            padding: const EdgeInsets.symmetric(vertical: 16), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
                            elevation: 0, 
                          ), 
                          child: _isLoading  
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                              : Text('Sign In', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)), 
                        ), 
                      ), 
                      const SizedBox(height: 24), 
                       
                      Row( 
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [ 
                          Text("Don't have an account? ", style: GoogleFonts.inter(color: Colors.black54)), 
                          GestureDetector( 
                            onTap: () => context.push('/signup'), 
                            child: Text( 
                              'Sign up', 
                              style: GoogleFonts.inter(color: ZenTokens.primary, fontWeight: FontWeight.w600), 
                            ), 
                          ), 
                        ], 
                      ) 
                    ], 
                  ), 
                ), 
              ), 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
}
