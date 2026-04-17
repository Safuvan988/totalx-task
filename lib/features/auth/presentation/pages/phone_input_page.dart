import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _onGetOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(SendOtpEvent(_phoneController.text.trim()));
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Illustration
                          Center(
                            child: Image.asset(
                              'assets/images/auth_illustration.png',
                              height: 160,
                              errorBuilder: (_, __, ___) => Container(
                                height: 160,
                                width: 160,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight
                                      .withValues(alpha: 0.1),
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
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Phone Number',
                              hintStyle: GoogleFonts.poppins(
                                color: AppColors.textHint,
                                fontSize: 14,
                              ),
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: AppColors.primary, width: 1.5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppColors.error),
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
                                    text:
                                        'By Continuing, I agree to TotalX\'s '),
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
                          const SizedBox(height: 28),
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
                  ));
            },
          ),
        ),
      ),
    );
  }
}
