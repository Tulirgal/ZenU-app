import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:provider/provider.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../core/auth/auth_service.dart'; 
import '../../core/theme/module_themes.dart'; 
import 'module_background.dart'; 
 
class SignInScreen extends StatefulWidget { 
  const SignInScreen({super.key}); 
  @override 
  State<SignInScreen> createState() => _SignInScreenState(); 
} 
 
class _SignInScreenState extends State<SignInScreen> { 
  final _emailCtrl    = TextEditingController(); 
  final _passwordCtrl = TextEditingController(); 
  final _formKey      = GlobalKey<FormState>(); 
  String? _error; 
  bool _obscure = true; 
 
  @override 
  void dispose() { 
    _emailCtrl.dispose(); _passwordCtrl.dispose(); super.dispose(); 
  } 
 
  Future<void> _submit() async { 
    if (!_formKey.currentState!.validate()) return; 
    setState(() => _error = null); 
    final ok = await context.read<AuthService>().signIn( 
      _emailCtrl.text.trim(), _passwordCtrl.text, 
    ); 
    if (!ok && mounted) { 
      setState(() => _error = 'Invalid email or password. Please try again.'); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.home; 
    final auth  = context.watch<AuthService>(); 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'home', 
        child: SafeArea( 
          child: Center( 
            child: SingleChildScrollView( 
              padding: const EdgeInsets.symmetric(horizontal: 24), 
              child: Container( 
                padding: const EdgeInsets.all(28), 
                decoration: BoxDecoration( 
                  color: theme.cardBg, 
                  borderRadius: BorderRadius.circular(24), 
                  border: Border.all(color: theme.cardBorder), 
                ), 
                child: Form( 
                  key: _formKey, 
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [ 
                      Text('Welcome back', 
                        style: GoogleFonts.inter( 
                          fontSize: 26, fontWeight: FontWeight.w700, 
                          color: theme.textPrimary, 
                        ), 
                      ).animate().fadeIn(duration: 400.ms), 
 
                      const SizedBox(height: 6), 
                      Text('Sign in to continue your ZenU journey.', 
                        style: GoogleFonts.inter(fontSize: 14, color: theme.textSecondary), 
                      ).animate().fadeIn(delay: 100.ms), 
 
                      if (_error != null) ...[ 
                        const SizedBox(height: 16), 
                        Container( 
                          padding: const EdgeInsets.all(12), 
                          decoration: BoxDecoration( 
                            color: const Color(0x1FF87171), 
                            borderRadius: BorderRadius.circular(10), 
                            border: Border.all(color: const Color(0x40F87171)), 
                          ), 
                          child: Text(_error!, 
                            style: GoogleFonts.inter(color: const Color(0xFFFCA5A5), fontSize: 13)), 
                        ), 
                      ], 
 
                      const SizedBox(height: 24), 
 
                      _GlassField( 
                        controller: _emailCtrl, 
                        label: 'Email', 
                        keyboardType: TextInputType.emailAddress, 
                        theme: theme, 
                        validator: (v) => (v?.contains('@') != true) ? 'Enter a valid email' : null, 
                      ).animate().fadeIn(delay: 200.ms), 
                      const SizedBox(height: 14), 
 
                      _GlassField( 
                        controller: _passwordCtrl, 
                        label: 'Password', 
                        obscure: _obscure, 
                        theme: theme, 
                        suffix: IconButton( 
                          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, 
                              color: theme.textSecondary, size: 18), 
                          onPressed: () => setState(() => _obscure = !_obscure), 
                        ), 
                        validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null, 
                      ).animate().fadeIn(delay: 300.ms), 
 
                      const SizedBox(height: 24), 
 
                      SizedBox( 
                        width: double.infinity, height: 50, 
                        child: ElevatedButton( 
                          onPressed: auth.isLoading ? null : _submit, 
                          style: ElevatedButton.styleFrom( 
                            backgroundColor: theme.accentColor, 
                            foregroundColor: Colors.white, 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), 
                          ), 
                          child: auth.isLoading 
                            ? const SizedBox(width: 18, height: 18, 
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                            : Text('Sign In', style: GoogleFonts.inter(fontWeight: FontWeight.w600, 
fontSize: 15)), 
                        ), 
                      ).animate().fadeIn(delay: 400.ms), 
 
                      const SizedBox(height: 20), 
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [ 
                        Text("Don't have an account?", 
                          style: GoogleFonts.inter(color: theme.textSecondary, fontSize: 13)), 
                        TextButton( 
                          onPressed: () => context.go('/signup'), 
                          child: Text('Create one', 
                            style: GoogleFonts.inter(color: theme.accentColor, fontWeight: 
FontWeight.w600)), 
                        ), 
                      ]).animate().fadeIn(delay: 500.ms), 
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
 
class _GlassField extends StatelessWidget { 
  final TextEditingController controller; 
  final String label; 
  final bool obscure; 
  final TextInputType? keyboardType; 
  final Widget? suffix; 
  final ModuleTheme theme; 
  final String? Function(String?)? validator; 
 
  const _GlassField({ 
    required this.controller, required this.label, required this.theme, 
    this.obscure = false, this.keyboardType, this.suffix, this.validator, 
  }); 
 
  @override 
  Widget build(BuildContext context) => TextFormField( 
    controller:   controller, 
    obscureText:  obscure, 
    keyboardType: keyboardType, 
    style: GoogleFonts.inter(color: theme.textPrimary, fontSize: 14), 
    validator: validator, 
    decoration: InputDecoration( 
      labelText: label, 
      labelStyle: GoogleFonts.inter(color: theme.textSecondary, fontSize: 13), 
      filled: true, 
      fillColor: theme.cardBg, 
      suffixIcon: suffix, 
      border: OutlineInputBorder( 
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(color: theme.cardBorder), 
      ), 
      enabledBorder: OutlineInputBorder( 
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(color: theme.cardBorder), 
      ), 
      focusedBorder: OutlineInputBorder( 
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(color: theme.accentColor, width: 1.5), 
), 
), 
); 
}
