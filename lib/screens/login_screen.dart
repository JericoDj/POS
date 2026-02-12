import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui'; // For ImageFilter
import '../constants/app_constants.dart';
import '../constants/app_dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    AppDimensions().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCQQjy2k9lj20LjYma0HoWTS1fvnSPPtJ0u0-vGrSA1W3NflxuT0NWlU2ML6qMIea-Dd2dtWnV0NnYKvmyuIoAm3UiVOzJZ62U7Fn0ifv0-G8eQB9QelR88xs7ihC7KnkubC4p-aTZLcECxH8Tw--8DfibXU48D-3t4WPxBeW37qJiW1C8GSYLmJ3VCHsKLTjUbbFJVDzpRGchQYcBoUiYgMfzvbv7g_AvvNdDSs57YK9F9diCnYW_p3a_UMte59OK9dBnIYiEMmPme',
              fit: BoxFit.cover,
            ),
          ),

          // Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(color: Colors.white.withValues(alpha: 0.8)),
            ),
          ),

          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Branding
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.primaryColor.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.storefront,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Leo\'s POS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.slate900,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Card
                  Container(
                    width:
                        AppDimensions.w(15).clamp(400.0, 600.0) +
                        (AppDimensions.isMobile
                            ? 0
                            : 100), // Adjusted logic for responsiveness example
                    constraints: BoxConstraints(maxWidth: AppDimensions.w(90)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                      border: Border.all(
                        color: const Color(0xFFF1F5F9),
                      ), // Slate 100
                      boxShadow: AppConstants.defaultShadow,
                    ),
                    child: Column(
                      children: [
                        // Login Form Section
                        Padding(
                          padding: const EdgeInsets.all(32), // p-8 md:p-10
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header
                                const Text(
                                  'Welcome back',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstants.slate900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Please enter your details to sign in.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B), // Slate 500
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Email Field
                                _buildLabel('Email Address'),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _emailController,
                                  hintText: 'Enter your email',
                                  icon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 20),

                                // Password Field
                                _buildLabel('Password'),
                                const SizedBox(height: 6),
                                _buildTextField(
                                  controller: _passwordController,
                                  hintText: '••••••••',
                                  icon: Icons.lock_outline,
                                  obscureText: !_isPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                    onPressed: () => setState(
                                      () => _isPasswordVisible =
                                          !_isPasswordVisible,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Remember Me & Forgot Password
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Checkbox(
                                            value: _rememberMe,
                                            activeColor:
                                                AppConstants.primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            onChanged: (value) => setState(
                                              () =>
                                                  _rememberMe = value ?? false,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Remember me',
                                          style: TextStyle(
                                            color: Color(0xFF475569),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: AppConstants.primaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Sign In Button
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle Sign In
                                    context.go('/');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shadowColor: AppConstants.primaryColor
                                        .withValues(alpha: 0.25),
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppDimensions.paddingM,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusM,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Google Sign In Button
                                OutlinedButton(
                                  onPressed: () {
                                    // Handle Google Sign In
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF334155),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFFE2E8F0),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Google Icon SVG representation (using Icons for simplicity or manual drawing if strict, sticking to icon for now or image asset if available. HTML had SVG path. I will use a placeholder Icon or Text since I don't have the asset).
                                      // Actually, I can leave the icon out or put a colored G.
                                      // Let's use a Text 'G' with colors for now to match strictness without assets.
                                      // Or better, just a simple storage-safe solution.
                                      RichText(
                                        text: const TextSpan(
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'G',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'o',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'o',
                                              style: TextStyle(
                                                color: Colors.orange,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'g',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'l',
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'e',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Sign in with Google',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account?",
                                      style: TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => context.go('/signup'),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Sign up for free',
                                        style: TextStyle(
                                          color: AppConstants.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom decorative strip
                        Container(
                          height: 6,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppConstants.primaryColor,
                                Color(0xFF6366F1), // Indigo 500
                                AppConstants.primaryColor,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Encryption Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock,
                          size: 16,
                          color: Color(0xFF16A34A),
                        ), // Green 600
                        const SizedBox(width: 8),
                        const Text(
                          'SECURE 256-BIT ENCRYPTION',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF334155),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFooterLink('Privacy Policy'),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '•',
                          style: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      ),
                      _buildFooterLink('Terms of Service'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF334155), // Slate 700
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          // Subtle shadow for input if needed, HTML doesn't explicitly have it but 'group-focus-within' details...
          // keeping it simple flat as per HTML classes 'bg-slate-50 border-slate-200'
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          filled: true,
          fillColor: const Color(0xFFF8FAFC), // Slate 50
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF94A3B8),
            size: 20,
          ), // Slate 400
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)), // Slate 200
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppConstants.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF475569), // Slate 600
        ),
      ),
    );
  }
}
