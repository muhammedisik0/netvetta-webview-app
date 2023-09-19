class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "https://netvetta.com";

  static const String loginEndpoint = "/login/do_login_app";

  static const String logoutEndpoint = "/login/logout";

  static const String notificationEndpoint =
      "/panel/index.php/test/test_bildirim_json";

  static const String loginUrl = baseUrl + loginEndpoint;

  static const String logOutUrl = baseUrl + logoutEndpoint;

  static const String notificationUrl = baseUrl + notificationEndpoint;
}
