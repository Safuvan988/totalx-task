import 'dart:async';
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

class OtpVerifyPage extends StatefulWidget {
  final String phone;
  final String reqId;

  const OtpVerifyPage({
    super.key,
    required this.phone,
    required this.reqId,
  });

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  static const int _otpLength = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  int _secondsRemaining = AppConstants.otpTimerSeconds;
  Timer? _timer;
  String _currentReqId = '';

  @override
  void initState() {
    super.initState();
    _currentReqId = widget.reqId;
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsRemaining = AppConstants.otpTimerSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  void _onVerify() {
    if (_enteredOtp.length == _otpLength) {
      context.read<AuthBloc>().add(
            VerifyOtpEvent(
              phoneNumber: widget.phone,
              otp: _enteredOtp,
              reqId: _currentReqId,
            ),
          );
    }
  }

  void _onResend() {
    context.read<AuthBloc>().add(ResendOtpEvent(widget.phone));
    for (final c in _controllers) {
      c.clear();
    }
    setState(() {});
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go(AppRouter.usersPath);
          } else if (state is OtpSent) {
            _currentReqId = state.authEntity.reqId;
            _startTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('OTP resent successfully!'),
                behavior: SnackBarBehavior.floating,
              ),
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
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Illustration
                    Center(
                      child: Image.asset(
                        'assets/images/otp_illustration.png',
                        height: 160,
                        errorBuilder: (_, __, ___) => Container(
                          height: 160,
                          width: 160,
                          decoration: BoxDecoration(
                            color:
                                AppColors.primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 72,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'OTP Verification',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the verification code we just sent to your number ${maskPhone(widget.phone)}.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Mock OTP hint ─────────────────────────────────────────
                    if (AppConstants.useMockOtp)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          border: Border.all(color: const Color(0xFFFFCA28)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline,
                                size: 18, color: Color(0xFFB45309)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Mock mode — use OTP: ${AppConstants.mockOtp}',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF92400E),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // ── OTP boxes with system keyboard ────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        _otpLength,
                        (index) => _OtpBox(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          onChanged: (value) {
                            if (value.length == 1 && index < _otpLength - 1) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            setState(() {});
                          },
                          onBackspace: () {
                            if (_controllers[index].text.isEmpty && index > 0) {
                              _controllers[index - 1].clear();
                              _focusNodes[index - 1].requestFocus();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Timer
                    Center(
                      child: Text(
                        _secondsRemaining > 0 ? '$_secondsRemaining Sec' : '00',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Resend
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Don't Get OTP? ",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: _secondsRemaining == 0 ? _onResend : null,
                            child: Text(
                              'Resend',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: _secondsRemaining == 0
                                    ? AppColors.primary
                                    : AppColors.textHint,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Verify button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed:
                                isLoading || _enteredOtp.length < _otpLength
                                    ? null
                                    : _onVerify,
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
                                    'Verify',
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
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}

// ── Individual OTP box ────────────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 54,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.otpBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: onChanged,
        // Handle backspace to jump to previous box
        onTapOutside: (_) => focusNode.unfocus(),
      ),
    );
  }
}
