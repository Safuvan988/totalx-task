import 'dart:async';
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
    _controllers =
        List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startTimer();
    // Request focus on first box
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

  String get _enteredOtp =>
      _controllers.map((c) => c.text).join();

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
    context
        .read<AuthBloc>()
        .add(ResendOtpEvent(widget.phone));
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _onKeypadDigit(String digit) {
    for (int i = 0; i < _otpLength; i++) {
      if (_controllers[i].text.isEmpty) {
        _controllers[i].text = digit;
        if (i < _otpLength - 1) {
          _focusNodes[i + 1].requestFocus();
        }
        setState(() {});
        return;
      }
    }
  }

  void _onKeypadDelete() {
    for (int i = _otpLength - 1; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        _controllers[i].clear();
        _focusNodes[i].requestFocus();
        setState(() {});
        return;
      }
    }
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
          // Resend successful – update reqId and restart timer
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: Image.asset(
                          'assets/images/otp_illustration.png',
                          height: 160,
                          errorBuilder: (_, __, ___) => Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(alpha: 0.1),
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
                      // OTP boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          _otpLength,
                          (index) => _OtpBox(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            isFilled: _controllers[index].text.isNotEmpty,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Timer
                      Center(
                        child: Text(
                          _secondsRemaining > 0
                              ? '$_secondsRemaining Sec'
                              : '00',
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
                              onTap: _secondsRemaining == 0
                                  ? _onResend
                                  : null,
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
                      const SizedBox(height: 24),
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
                    ],
                  ),
                ),
              ),
              // Custom keypad
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
        if (key.isEmpty) return Expanded(child: const SizedBox());
        return Expanded(
          child: _KeypadButton(
            label: key,
            onTap: () {
              if (key == 'del') {
                _onKeypadDelete();
              } else {
                _onKeypadDigit(key.split('\n').first);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFilled;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.isFilled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(
          color: isFilled ? AppColors.primary : AppColors.otpBorder,
          width: isFilled ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.surface,
      ),
      alignment: Alignment.center,
      child: Text(
        controller.text,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
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
