import 'package:eshop_app/app/routes/app_pages.dart';
import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:eshop_app/presentation/widgets/custom_buttonwidget.dart';
import 'package:eshop_app/presentation/widgets/otp_fields_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends StatelessWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return _OtpScreenContent(email: email);
  }
}

class _OtpScreenContent extends StatelessWidget {
  final String email;

  const _OtpScreenContent({required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.success &&
            state.action == AppAction.verifyEmail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Verified'),
              backgroundColor: Colors.green,
            ),
          );
          context.go(AppRoutes.login);
        } else if (state.status == AppStatus.success &&
            state.action == AppAction.resendOtp) {
          context.read<AppCubit>().resendOtpTimer();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'OTP resent'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == AppStatus.failure &&
            (state.action == AppAction.verifyEmail ||
                state.action == AppAction.resendOtp)) {
          context.read<AppCubit>().setOtpError(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Something went wrong'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Verify your email',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'We sent a 6-digit code to\n'),
                      TextSpan(
                        text: email,
                        style: const TextStyle(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                const OtpFieldsWidget(length: 6),
                const SizedBox(height: 48),
                BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    final isLoading = state.status == AppStatus.loading;
                    return CustomButton(
                      text: 'Verify',
                      isLoading: isLoading,
                      onPressed: () {
                        if (state.otpCode.length == 6) {
                          context.read<AppCubit>().verifyEmail(
                            email: email,
                            otp: state.otpCode,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter the complete 6-digit verification code',
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: BlocBuilder<AppCubit, AppState>(
                    builder: (context, state) {
                      if (state.canResend) {
                        return GestureDetector(
                          onTap: () {
                            context.read<AppCubit>().resendOtp(email: email);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('OTP resent successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        );
                      }
                      return Text(
                        "Resend code in ${state.secondsRemaining}s",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
