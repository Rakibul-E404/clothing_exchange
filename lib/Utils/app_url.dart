class AppUrl {
  AppUrl._();

  static String baseUrl = 'https://d7001.sobhoy.com/api/v1';
  static String imageBaseUrl = 'https://d7001.sobhoy.com/';
  static String userProfileUrl = '$baseUrl/users/self/in';
  static String authRegister = '$baseUrl/auth/register';
  static String authLogin = '$baseUrl/auth/login';
  static String verifyEmail = '$baseUrl/auth/verify-email';
  static String resetPassword = '$baseUrl/auth/reset-password';
  static String forgotPassword = '$baseUrl/auth/forgot-password';
  static String allProduct = '$baseUrl/products/all?page=1&limit=100000';
  static String wishlistEndPoint = '$baseUrl/favorite';
  static String productHistory = '$baseUrl/products/history';
  static String changePassword = '$baseUrl/auth/change-password';
  static String conversationEndPoint = '$baseUrl/conversation/conversation_list';
  static String inboxEndPoint(conversationID) => '$baseUrl/conversation/get-messages?conversationId=$conversationID';

  static String sentMessageEndPoint= "$baseUrl/conversation/send_message" ;
  static String conversationCreateEndPoint= "$baseUrl/conversation/create" ;

  static String getSingleConversation(String conversationId) {
    return '$baseUrl/conversation/get-messages?conversationId=$conversationId';
  }
}
