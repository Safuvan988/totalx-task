import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class PhoneInputPage extends StatefulWidget {
  const PhoneInputPage({super.key});

  @override
  State<PhoneInputPage> createState() => _PhoneInputPageState();
}

class _PhoneInputPageState extends State<PhoneInputPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Custom numeric keypad digits display
  void _appendDigit(String digit) {
    final current = _phoneController.text;
    if (current.length < 10) {
      _phoneController.text = current + digit;
    }
  }

  void _deleteDigit() {
    final current = _phoneController.text;
    if (current.isNotEmpty) {
      _phoneController.text = current.substring(0, current.length - 1);
    }
  }

  void _onGetOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<AuthBloc>()
          .add(SendOtpEvent(_phoneController.text.trim()));
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
          context.push(
            AppRouter.otpPath,
            extra: {
              'phone': state.authEntity.phoneNumber,
              'reqId': state.authEntity.reqId,
            },
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Top section: illustration + form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        // Illustration
                        Center(
                          child: Image.asset(
                            'assets/images/auth_illustration.png',
                            height: 160,
                            errorBuilder: (_, __, ___) => Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: const Icon(
                                Icons.phone_android,
                                size: 72,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Enter Phone Number',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Phone field
                        TextFormField(
                          controller: _phoneController,
                          readOnly: true, // input via custom keypad
                          keyboardType: TextInputType.none,
                          decoration: InputDecoration(
                            hintText: 'Enter Phone Number',
                            hintStyle: GoogleFonts.poppins(
                              color: AppColors.textHint,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.border),
                            ),
                          ),
                          validator: validatePhone,
                        ),
                        const SizedBox(height: 12),
                        // Terms & Conditions
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              const TextSpan(
                                  text: 'By Continuing, I agree to TotalX\'s '),
                              TextSpan(
                                text: 'Terms and condition',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                              const TextSpan(text: ' & '),
                              TextSpan(
                                text: 'privacy policy',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Get OTP button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _onGetOtp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.textPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Get OTP',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
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
                ),
              ),
              // Custom numeric keypad
              _buildKeypad(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _buildKeyRow(['1', '2\nABC', '3\nDEF']),
          _buildKeyRow(['4\nGHI', '5\nJKL', '6\nMNO']),
          _buildKeyRow(['7\nPQRS', '8\nTUV', '9\nWXYZ']),
          _buildKeyRow(['', '0', 'del']),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        if (key.isEmpty) return const Expanded(child: SizedBox());
        return Expanded(
          child: _KeypadButton(
            label: key,
            onTap: () {
              if (key == 'del') {
                _deleteDigit();
              } else {
                _appendDigit(key.split('\n').first);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeypadButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final lines = label.split('\n');
    final isDelete = label == 'del';

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        alignment: Alignment.center,
        child: isDelete
            ? const Icon(Icons.backspace_outlined,
                size: 22, color: AppColors.textPrimary)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    lines[0],
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (lines.length > 1)
                    Text(
                      lines[1],
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
