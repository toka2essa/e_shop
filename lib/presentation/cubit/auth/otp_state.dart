class OtpState {
  final List<String> digits;
  final int secondsRemaining;
  final bool canResend;
  final bool isError;

  const OtpState({
    List<String>? digits,
    this.secondsRemaining = 60,
    this.canResend = false,
    this.isError = false,
  }) : digits = digits ?? const ['', '', '', '', '', ''];

  String get code => digits.join();

  OtpState copyWith({
    List<String>? digits,
    int? secondsRemaining,
    bool? canResend,
    bool? isError,
  }) {
    return OtpState(
      digits: digits ?? this.digits,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      canResend: canResend ?? this.canResend,
      isError: isError ?? this.isError,
    );
  }
}
