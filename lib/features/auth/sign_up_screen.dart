import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:provider/provider.dart'; 
import '../../core/auth/auth_service.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class SignUpScreen extends StatefulWidget { 
  const SignUpScreen({super.key}); 
 
  @override 
  State<SignUpScreen> createState() => _SignUpScreenState(); 
} 
 
class _SignUpScreenState extends State<SignUpScreen> { 
  final _nameCtrl = TextEditingController(); 
  final _emailCtrl = TextEditingController(); 
  final _passwordCtrl = TextEditingController(); 
  String? _formError; 
  bool _isLoading = false; 
 
  @override 
  void dispose() { 
    _nameCtrl.dispose(); 
    _emailCtrl.dispose(); 
    _passwordCtrl.dispose(); 
    super.dispose(); 
  } 
 
  Future<void> _handleSignUp() async { 
    final name = _nameCtrl.text.trim(); 
    final email = _emailCtrl.text.trim(); 
    final password = _passwordCtrl.text.trim(); 
     
    if (name.isEmpty || email.isEmpty || password.isEmpty) { 
      setState(() => _formError = 'Please fill in all fields.'); 
      return; 
    } 
    if (password.length < 8) { 
      setState(() => _formError = 'Password must be at least 8 characters.'); 
      return; 
    } 
     
    setState(() { 
      _formError = null; 
      _isLoading = true; 
    }); 
 
    final authService = context.read<AuthService>(); 
    final success = await authService.signUp(email, password, name); 
     
    if (!mounted) return; 
     
    setState(() => _isLoading = false); 
     
    if (success) { 
      context.go('/'); 
    } else { 
      setState(() => _formError = 'Sign-up failed. Please try again.'); 
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
                          color: ZenTokens.secondary.withValues(alpha: 0.15), 
                          shape: BoxShape.circle, 
                        ), 
                        child: Icon(Icons.person_add_rounded, color: ZenTokens.secondary), 
                      ), 
                      const SizedBox(height: 16), 
                      Text( 
                        'Create your account', 
                        style: GoogleFonts.lora(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87, letterSpacing: -0.5), 
                        textAlign: TextAlign.center, 
                      ), 
                      const SizedBox(height: 8), 
                      Text( 
                        'Join and begin your calm journey.', 
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
                        controller: _nameCtrl, 
                        textCapitalization: TextCapitalization.words, 
                        decoration: InputDecoration( 
                          labelText: 'Full Name', 
                          hintText: 'Jane Doe', 
                          labelStyle: GoogleFonts.inter(color: Colors.black54), 
                          filled: true, 
                          fillColor: Colors.white.withValues(alpha: 0.6), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), 
                        ), 
                      ), 
                      const SizedBox(height: 16), 
 
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
                          hintText: 'Min 8 characters', 
                          labelStyle: GoogleFonts.inter(color: Colors.black54), 
                          filled: true, 
                          fillColor: Colors.white.withValues(alpha: 0.6), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), 
                        ), 
                      ), 
                      const SizedBox(height: 32), 
                       
                      SizedBox( 
                        width: double.infinity, 
                        child: ElevatedButton( 
                          onPressed: _isLoading ? null : _handleSignUp, 
                          style: ElevatedButton.styleFrom( 
                            backgroundColor: ZenTokens.primary, 
                            foregroundColor: Colors.white, 
                            padding: const EdgeInsets.symmetric(vertical: 16), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
                            elevation: 0, 
                          ), 
                          child: _isLoading  
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                              : Text('Sign Up', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)), 
                        ), 
                      ), 
                      const SizedBox(height: 24), 
                       
                      Row( 
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [ 
                          Text("Already have an account? ", style: GoogleFonts.inter(color: Colors.black54)), 
                          GestureDetector( 
                            onTap: () => context.pop(), 
                            child: Text( 
                              'Sign in', 
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
