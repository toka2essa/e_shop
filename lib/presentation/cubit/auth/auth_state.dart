abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess(this.message);
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}

class OtpResent extends AuthState {
  final String message;
  const OtpResent(this.message);
}

class EmailVerified extends AuthState {
  final String message;
  const EmailVerified(this.message);
}
