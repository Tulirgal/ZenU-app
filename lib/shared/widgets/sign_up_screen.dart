import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import 'module_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthService>();
    final success = await auth.signUp(
      _emailController.text,
      _passwordController.text,
      _fullNameController.text, // Passed as name
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.go('/dashboard');
      } else {
        setState(() => _errorMessage = 'Failed to sign up. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'home',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      if (_errorMessage != null) _buildError(),
                      const SizedBox(height: 24),
                      _buildForm(),
                      const SizedBox(height: 24),
                      _buildDivider(),
                      const SizedBox(height: 24),
                      _buildGoogleButton(),
                      const SizedBox(height: 24),
                      _buildFooter(),
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

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: ZenTokens.zenSecondary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_add_rounded,
            color: ZenTokens.zenSecondary,
            size: 24,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Create your ZenU account',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: ZenTokens.zenFg,
            letterSpacing: -0.03 * 28,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Join and begin your calm journey.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ZenTokens.zenFgMuted,
            height: 1.55,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ZenTokens.zenDanger.withValues(alpha: 0.1),
        border: Border.all(color: ZenTokens.zenDanger.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(ZenTokens.radiusZenLg),
      ),
      child: Text(
        _errorMessage!,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: ZenTokens.zenDanger,
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInput(
            label: 'Email',
            controller: _emailController,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email address' : null,
          ),
          const SizedBox(height: 20),
          _buildInput(
            label: 'Password',
            controller: _passwordController,
            placeholder: 'At least 8 characters',
            obscureText: true,
            validator: (v) => v == null || v.length < 8 ? 'Password must be at least 8 characters' : null,
          ),
          const SizedBox(height: 20),
          _buildInput(
            label: 'Full name (optional)',
            controller: _fullNameController,
            placeholder: 'Sage Traveler',
          ),
          const SizedBox(height: 20),
          _buildInput(
            label: 'Username (optional)',
            controller: _usernameController,
            placeholder: 'zenu-traveler',
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: ZenTokens.zenPrimary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ZenTokens.radiusZenMd),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Create account'),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ZenTokens.zenFg,
            letterSpacing: 0.08 * 12,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: ZenTokens.zenFg,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: ZenTokens.zenFgMuted.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ZenTokens.radiusZenMd),
              borderSide: const BorderSide(color: ZenTokens.zenBorderSoft),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ZenTokens.radiusZenMd),
              borderSide: const BorderSide(color: ZenTokens.zenBorderSoft),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ZenTokens.radiusZenMd),
              borderSide: const BorderSide(color: ZenTokens.zenPrimary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ZenTokens.radiusZenMd),
              borderSide: const BorderSide(color: ZenTokens.zenDanger),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(color: ZenTokens.zenBorderSoft, height: 1, thickness: 1),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'or',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: ZenTokens.zenFgMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.g_mobiledata_rounded, size: 24, color: ZenTokens.zenFg),
      label: const Text('Continue with Google'),
      style: OutlinedButton.styleFrom(
        foregroundColor: ZenTokens.zenFg,
        minimumSize: const Size.fromHeight(44),
        side: const BorderSide(color: ZenTokens.zenBorderSoft),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ZenTokens.radiusZenMd),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: ZenTokens.zenFgMuted,
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/signin'),
          child: Text(
            'Sign in instead',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ZenTokens.zenPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
