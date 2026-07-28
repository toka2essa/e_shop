abstract class EndPoints {
  static const String baseUrl = 'https://accessories-eshop.runasp.net/api/';

  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String verifyEmail = 'auth/verify-email';
  static const String resendOtp = 'auth/resend-otp';

  static const String products = 'products';
  static String productDetails(String id) => 'products/$id';

  static const String categories = 'categories';
  static String categoryDetails(String id) => 'categories/$id';
}
