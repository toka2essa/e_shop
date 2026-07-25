import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  Timer? _timer;

  OtpCubit() : super(const OtpState()) {
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    emit(state.copyWith(secondsRemaining: 60, canResend: false));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        emit(state.copyWith(secondsRemaining: state.secondsRemaining - 1));
      } else {
        emit(state.copyWith(canResend: true));
        _timer?.cancel();
      }
    });
  }

  void updateCode(String code) {
    final digits = List.generate(
      6,
      (index) => index < code.length ? code[index] : '',
    );
    emit(state.copyWith(digits: digits, isError: false));
  }

  void updateDigit(int index, String value) {
    final digits = List<String>.from(state.digits);
    digits[index] = value;
    emit(state.copyWith(digits: digits, isError: false));
  }

  void setError() {
    emit(state.copyWith(isError: true));
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isClosed) emit(state.copyWith(isError: false));
    });
  }

  void resend() {
    if (state.canResend) {
      emit(state.copyWith(digits: List.filled(6, '')));
      _startTimer();
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
