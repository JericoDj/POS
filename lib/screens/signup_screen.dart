import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../constants/app_dimensions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');
  double _passwordStrength = 0;
  String _initialCountry = 'US';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty && placemarks.first.isoCountryCode != null) {
        if (mounted) {
          setState(() {
            _initialCountry = placemarks.first.isoCountryCode!;
            _phoneNumber = PhoneNumber(isoCode: _initialCountry);
          });
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _updatePasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
    setState(() {
      _passwordStrength = strength;
    });
  }

  Color _getStrengthColor() {
    if (_passwordStrength <= 0.25) return Colors.red;
    if (_passwordStrength <= 0.5) return Colors.orange;
    if (_passwordStrength <= 0.75) return Colors.yellow;
    return Colors.green;
  }

  String _getStrengthText() {
    if (_passwordStrength <= 0.25) return 'Weak';
    if (_passwordStrength <= 0.5) return 'Fair';
    if (_passwordStrength <= 0.75) return 'Good';
    return 'Strong';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions().init(context);
    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      body: Row(
        children: [
          // Left Brand Panel (Desktop/Tablet only)
          if (!AppDimensions.isMobile)
            Expanded(
              flex: 5, // ~45% width
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.network(
                    'https://cdn.selldone.com/app/contents/articles/220208bestfreepossoftwareforsmallbusinessesjpgb72d2b70ac5498e55ec1df432ac37f66.jpg',
                    fit: BoxFit.cover,
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        Row(
                          children: [
                            Container(
                              width: AppDimensions.w(
                                4,
                              ).clamp(48.0, 64.0), // Responsive icon size
                              height: AppDimensions.w(4).clamp(48.0, 64.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusS,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Leos POS",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Text(
                          'Powering modern businesses.',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureItem('Offline Sync capable'),
                        _buildFeatureItem('Multi-branch inventory support'),
                        _buildFeatureItem('Real-time revenue analytics'),
                        const SizedBox(height: 48),
                        // Testimonial
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.primaryColor,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.primaryColor,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.primaryColor,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.primaryColor,
                                    size: 20,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.primaryColor,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '"This POS changed how we manage our inventory entirely. The offline sync saved us during our busiest weekend."',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDeDbaalOKBSEzXpNLeNNzNhxhB2cSVu6iItocknJfV0wqhMXj2OtxoqU5WTrbFV4bSnJ1PARA4zHGZYyPE8G45O8UKWfQEEWeKJAK93Tu5d9-j90t6_r7omPQ153l71mOed_x2CFMJQ95tG_69CBQveWlkU2LF25iPcARhNqE32T_heK8T4k8cWTa3ZMrYzKIsoCIVsHwUU6dWxnzA5RIzpkuDhEZlWyzforLE4JtayuJH9KNRB_QoGnwNLi-xt65Nnq6QiaYxI3cb',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Jane Doe',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        'Retail Owner, The Green Loft',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Right Form Panel
          Expanded(
            flex: 6, // ~55% width
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                  vertical: AppDimensions.paddingXL,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: AppDimensions.w(90)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mobile Logo
                      if (AppDimensions.isMobile)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Leo\'s POS',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Stepper
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text(
                      //       'Step 1 of 2',
                      //       style: TextStyle(
                      //         color: AppConstants.primaryColor,
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 14,
                      //       ),
                      //     ),
                      //     Text(
                      //       'Account Details',
                      //       style: TextStyle(
                      //         color: Colors.grey[600],
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 14,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 8),
                      // Container(
                      //   height: 8,
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey[200],
                      //     borderRadius: BorderRadius.circular(4),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         flex: 1,
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //             color: AppConstants.primaryColor,
                      //             borderRadius: BorderRadius.circular(4),
                      //           ),
                      //         ),
                      //       ),
                      //       const Expanded(flex: 1, child: SizedBox()),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 32),

                      // Header
                      const Text(
                        'Create your account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Text(
                      //   'Start your 14-day free trial. No credit card required.',
                      //   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      // ),
                      //
                      // const SizedBox(height: 24),
                      //
                      // // Google Sign in
                      // OutlinedButton.icon(
                      //   onPressed: () {},
                      //   style: OutlinedButton.styleFrom(
                      //     padding: const EdgeInsets.symmetric(vertical: 12),
                      //     backgroundColor: Colors.white,
                      //     side: BorderSide(color: Colors.grey[300]!),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     foregroundColor: Colors.grey[700],
                      //   ),
                      //   icon: Image.network(
                      //     'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                      //     height: 20,
                      //     width: 20,
                      //     errorBuilder: (context, error, stackTrace) =>
                      //         const Icon(Icons.g_mobiledata),
                      //   ),
                      //   label: const Text(
                      //     'Sign up with Google',
                      //     style: TextStyle(fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      //
                      // const SizedBox(height: 24),
                      //
                      // // Divider
                      // const Row(
                      //   children: [
                      //     Expanded(child: Divider()),
                      //     Padding(
                      //       padding: EdgeInsets.symmetric(horizontal: 16),
                      //       child: Text(
                      //         'OR CONTINUE WITH EMAIL',
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           color: Colors.grey,
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(child: Divider()),
                      //   ],
                      // ),
                      const SizedBox(height: 24),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Full Name'),
                            TextFormField(
                              controller: _nameController,
                              decoration: _inputDecoration(
                                hintText: 'John Doe',
                                icon: Icons.person_outline,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            _buildLabel('Work Email'),
                            TextFormField(
                              controller: _emailController,
                              decoration: _inputDecoration(
                                hintText: 'you@company.com',
                                icon: Icons.mail_outlined,
                              ),
                            ),
                            const SizedBox(height: 20),

                            _buildLabel('Password'),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              onChanged: _updatePasswordStrength,
                              decoration: _inputDecoration(
                                hintText: '••••••••',
                                icon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Strength meter
                            if (_passwordController.text.isNotEmpty) ...[
                              Row(
                                children: List.generate(4, (index) {
                                  return Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 4),
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: index < (_passwordStrength * 4)
                                            ? _getStrengthColor()
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _getStrengthText(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getStrengthColor(),
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 20),

                            _buildLabel('Phone Number'),
                            Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  _phoneNumber = number;
                                },

                                selectorConfig: const SelectorConfig(
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
                                  useBottomSheetSafeArea: true,
                                  leadingPadding: 0,
                                  trailingSpace: false,
                                ),

                                initialValue: _phoneNumber,
                                textFieldController: _phoneController,
                                formatInput: true,
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,

                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      signed: false,
                                      decimal: false,
                                    ),

                                selectorTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),

                                textAlign:
                                    TextAlign.start, // ⭐ centers hint & input
                                textAlignVertical: TextAlignVertical.center,

                                inputBorder: InputBorder.none,

                                inputDecoration: const InputDecoration(
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.zero, // ⭐ IMPORTANT
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            Consumer<AuthProvider>(
                              builder: (context, provider, child) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: provider.isLoading
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              try {
                                                await provider.register(
                                                  email: _emailController.text
                                                      .trim(),
                                                  password: _passwordController
                                                      .text
                                                      .trim(),
                                                  displayName: _nameController
                                                      .text
                                                      .trim(),
                                                  phoneNumber:
                                                      _phoneNumber
                                                          .phoneNumber ??
                                                      _phoneController.text
                                                          .trim(),
                                                );
                                                if (context.mounted) {
                                                  context.go('/');
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Registration failed: ${e.toString().replaceAll('Exception:', '')}',
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppConstants.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: provider.isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Create Account',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/login'),
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 14,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon) : null,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }
}
