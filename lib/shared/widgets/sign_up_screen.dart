import 'dart:ui'; 
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:provider/provider.dart'; 
import '../../core/auth/auth_service.dart'; 
import '../../core/theme/app_theme.dart'; 
import 'module_background.dart'; 
 
class SignUpScreen extends StatefulWidget { 
  const SignUpScreen({super.key}); 
 
  @override 
  State<SignUpScreen> createState() => _SignUpScreenState(); 
} 
 
class _SignUpScreenState extends State<SignUpScreen> { 
  final _emailCtrl = TextEditingController(); 
  final _passwordCtrl = TextEditingController(); 
  final _fullNameCtrl = TextEditingController(); 
  final _usernameCtrl = TextEditingController(); 
  final _formKey = GlobalKey<FormState>(); 
  bool _isLoading = false; 
  String? _error; 
 
  final Color _danger = const Color(0xFFE01E1E); 
  final Color _dangerSoft = const Color(0xFFFAE3E3); 
 
  Future<void> _submit() async { 
    if (!_formKey.currentState!.validate()) return; 
    setState(() { 
      _isLoading = true; 
      _error = null; 
    }); 
 
    try { 
      await context.read<AuthService>().signUp( 
            _emailCtrl.text.trim(), 
            _passwordCtrl.text, 
            _fullNameCtrl.text.trim(), 
            _usernameCtrl.text.trim(), 
          ); 
    } catch (e) { 
      setState(() => _error = e.toString().replaceAll('Exception: ', '')); 
    } finally { 
      if (mounted) setState(() => _isLoading = false); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'home', 
        child: Center( 
          child: SingleChildScrollView( 
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64), 
            child: ConstrainedBox( 
              constraints: const BoxConstraints(maxWidth: 440), 
              child: ClipRRect( 
                borderRadius: BorderRadius.circular(ZenTokens.radius2xl), 
                child: BackdropFilter( 
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), 
                  child: Container( 
                    padding: const EdgeInsets.all(32), 
                    decoration: BoxDecoration( 
                      color: Colors.white.withValues(alpha: 0.75), 
                      borderRadius: BorderRadius.circular(ZenTokens.radius2xl), 
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4)), 
                      boxShadow: [ 
                        BoxShadow( 
                          color: const Color(0xFF1E295A).withValues(alpha: 0.08), 
                          blurRadius: 32, 
                          offset: const Offset(0, 16), 
                        ) 
                      ], 
                    ), 
                    child: Form( 
                      key: _formKey, 
                      child: Column( 
                        mainAxisSize: MainAxisSize.min, 
                        crossAxisAlignment: CrossAxisAlignment.stretch, 
                        children: [ 
                          Center( 
                            child: Container( 
                              width: 48, 
                              height: 48, 
                              decoration: BoxDecoration( 
                                color: ZenTokens.secondary.withValues(alpha: 0.1), 
                                shape: BoxShape.circle, 
                              ), 
                              child: Icon( 
                                Icons.person_add_rounded, 
                                color: ZenTokens.secondary, 
                                size: 24, 
                              ), 
                            ), 
                          ), 
                          const SizedBox(height: 16), 
                          Text( 
                            'Create your ZenU account', 
                            textAlign: TextAlign.center, 
                            style: GoogleFonts.lora( 
                              fontSize: 32, 
                              fontWeight: FontWeight.w600, 
                              letterSpacing: -0.5, 
                              color: ZenTokens.fg, 
                            ), 
                          ), 
                          const SizedBox(height: 8), 
                          Text( 
                            'Join and begin your calm journey.', 
                            textAlign: TextAlign.center, 
                            style: GoogleFonts.inter( 
                              fontSize: 14, 
                              color: ZenTokens.fgMuted, 
                            ), 
                          ), 
                          const SizedBox(height: 24), 
                          if (_error != null) ...[ 
                            Container( 
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
                              decoration: BoxDecoration( 
                                color: _dangerSoft, 
                                borderRadius: BorderRadius.circular(ZenTokens.radiusLg), 
                                border: Border.all(color: _danger.withValues(alpha: 0.25)), 
                              ), 
                              child: Text( 
                                _error!, 
                                style: GoogleFonts.inter( 
                                  fontSize: 14, 
                                  color: _danger, 
                                ), 
                              ), 
                            ), 
                            const SizedBox(height: 20), 
                          ], 
                          _buildLabel('Email'), 
                          const SizedBox(height: 6), 
                          _buildInput( 
                            controller: _emailCtrl, 
                            placeholder: 'you@example.com', 
                            keyboardType: TextInputType.emailAddress, 
                          ), 
                          const SizedBox(height: 20), 
                          _buildLabel('Password'), 
                          const SizedBox(height: 6), 
                          _buildInput( 
                            controller: _passwordCtrl, 
                            placeholder: 'At least 8 characters', 
                            obscureText: true, 
                          ), 
                          const SizedBox(height: 20), 
                          _buildLabel('Full name (optional)'), 
                          const SizedBox(height: 6), 
                          _buildInput( 
                            controller: _fullNameCtrl, 
                            placeholder: 'Sage Traveler', 
                            isRequired: false, 
                          ), 
                          const SizedBox(height: 20), 
                          _buildLabel('Username (optional)'), 
                          const SizedBox(height: 6), 
                          _buildInput( 
                            controller: _usernameCtrl, 
                            placeholder: 'zenu-traveler', 
                            isRequired: false, 
                          ), 
                          const SizedBox(height: 24), 
                          SizedBox( 
                            height: 44, 
                            child: ElevatedButton( 
                              onPressed: _isLoading ? null : _submit, 
                              style: ElevatedButton.styleFrom( 
                                backgroundColor: ZenTokens.primary, 
                                foregroundColor: Colors.white, 
                                elevation: 0, 
                                shape: RoundedRectangleBorder( 
                                  borderRadius: BorderRadius.circular(ZenTokens.radiusLg), 
                                ), 
                              ), 
                              child: _isLoading 
                                  ? const SizedBox( 
                                      width: 20, 
                                      height: 20, 
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white), 
                                    ) 
                                  : Text( 
                                      'Create account', 
                                      style: GoogleFonts.inter( 
                                        fontSize: 14, 
                                        fontWeight: FontWeight.w500, 
                                      ), 
                                    ), 
                            ), 
                          ), 
                          const SizedBox(height: 24), 
                          Row( 
                            children: [ 
                              Expanded(child: Divider(color: ZenTokens.borderSoft)), 
                              Padding( 
                                padding: const EdgeInsets.symmetric(horizontal: 16), 
                                child: Text( 
                                  'or', 
                                  style: GoogleFonts.inter( 
                                    fontSize: 12, 
                                    color: ZenTokens.fgSubtle, 
                                  ), 
                                ), 
                              ), 
                              Expanded(child: Divider(color: ZenTokens.borderSoft)), 
                            ], 
                          ), 
                          const SizedBox(height: 24), 
                          _buildGoogleButton(), 
                          const SizedBox(height: 24), 
                          Row( 
                            mainAxisAlignment: MainAxisAlignment.center, 
                            children: [ 
                              Text( 
                                "Already have an account? ", 
                                style: GoogleFonts.inter( 
                                  fontSize: 14, 
                                  color: ZenTokens.fgMuted, 
                                ), 
                              ), 
                              GestureDetector( 
                                onTap: () => context.go('/signin'), 
                                behavior: HitTestBehavior.opaque, 
                                child: Text( 
                                  'Sign in instead', 
                                  style: GoogleFonts.inter( 
                                    fontSize: 14, 
                                    fontWeight: FontWeight.w500, 
                                    color: ZenTokens.primary, 
                                  ), 
                                ), 
                              ), 
                            ], 
                          ), 
                        ], 
                      ), 
                    ), 
                  ), 
                ), 
              ), 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildLabel(String text) { 
    return Text( 
      text, 
      style: GoogleFonts.inter( 
        fontSize: 14, 
        fontWeight: FontWeight.w600, 
        color: ZenTokens.fgMuted, 
      ), 
    ); 
  } 
 
  Widget _buildInput({ 
    required TextEditingController controller, 
    required String placeholder, 
    bool obscureText = false, 
    bool isRequired = true, 
    TextInputType? keyboardType, 
  }) { 
    return SizedBox( 
      height: 44, 
      child: TextFormField( 
        controller: controller, 
        obscureText: obscureText, 
        keyboardType: keyboardType, 
        style: GoogleFonts.inter( 
          fontSize: 14, 
          color: ZenTokens.fg, 
        ), 
        decoration: InputDecoration( 
          hintText: placeholder, 
          hintStyle: GoogleFonts.inter( 
            fontSize: 14, 
            color: ZenTokens.fgSubtle, 
          ), 
          filled: true, 
          fillColor: Colors.white, 
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0), 
          border: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(ZenTokens.radiusSm), 
            borderSide: const BorderSide(color: ZenTokens.border), 
          ), 
          enabledBorder: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(ZenTokens.radiusSm), 
            borderSide: const BorderSide(color: ZenTokens.border), 
          ), 
          focusedBorder: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(ZenTokens.radiusSm), 
            borderSide: const BorderSide(color: ZenTokens.primary, width: 2), 
          ), 
          errorBorder: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(ZenTokens.radiusSm), 
            borderSide: BorderSide(color: _danger, width: 1), 
          ), 
        ), 
        validator: isRequired 
            ? (value) => value == null || value.isEmpty ? 'Required' : null 
            : null, 
      ), 
    ); 
  } 
 
  Widget _buildGoogleButton() { 
    return SizedBox( 
      height: 44, 
      child: OutlinedButton( 
        onPressed: () {}, 
        style: OutlinedButton.styleFrom( 
          backgroundColor: Colors.white, 
          foregroundColor: ZenTokens.fg, 
          side: const BorderSide(color: ZenTokens.border), 
          elevation: 0, 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(ZenTokens.radiusLg), 
          ), 
        ), 
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [ 
            const Icon(Icons.g_mobiledata_rounded, size: 28), 
            const SizedBox(width: 8), 
            Text( 
              'Continue with Google', 
              style: GoogleFonts.inter( 
                fontSize: 14, 
                fontWeight: FontWeight.w500, 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}
