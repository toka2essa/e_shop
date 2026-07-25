import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpTimerCubit extends Cubit<int> {
  Timer? _timer;

  OtpTimerCubit() : super(60);

  void startTimer() {
    emit(60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        emit(state - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
