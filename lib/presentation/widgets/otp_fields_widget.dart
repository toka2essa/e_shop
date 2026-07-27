import 'package:eshop_app/core/theme/app_colors.dart';
import 'package:eshop_app/core/theme/app_design.dart';
import 'package:eshop_app/presentation/cubit/app/app_cubit.dart';
import 'package:eshop_app/presentation/cubit/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpFieldsWidget extends StatelessWidget {
  final int length;

  const OtpFieldsWidget({super.key, this.length = 6});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) =>
          previous.otpError != current.otpError ||
          (previous.otpCode.isNotEmpty && current.otpCode.isEmpty),
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            length,
            (index) => SizedBox(
              width: 45,
              height: 55,
              child: TextFormField(
                key: ValueKey('otp_field_${index}_${state.otpCode.isEmpty}'),
                autofocus: index == 0,
                onChanged: (value) {
                  context.read<AppCubit>().updateOtpDigit(index, value);
                  if (value.length == 1 && index < length - 1) {
                    FocusScope.of(context).nextFocus();
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).previousFocus();
                  }
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDesign.buttonRadius),
                    borderSide: BorderSide(
                      color: state.otpError
                          ? Colors.red
                          : AppColors.secondaryButtonColor,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDesign.buttonRadius),
                    borderSide: BorderSide(
                      color: state.otpError
                          ? Colors.red
                          : AppColors.primaryOrange,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
