class AppUrl {
  AppUrl._();
  static String imageBaseUrl = 'https://d7001.sobhoy.com/';
  static String baseUrl = 'https://d7001.sobhoy.com/api/v1';
  static String userProfileUrl = '$baseUrl/users/self/in';
  static String authRegister = '$baseUrl/auth/register';
  static String authLogin = '$baseUrl/auth/login';
  static String verifyEmail = '$baseUrl/auth/verify-email';
  static String resetPassword = '$baseUrl/auth/reset-password';
  static String forgotPassword = '$baseUrl/auth/forgot-password';
  static String allProduct = '$baseUrl/products/all';

}