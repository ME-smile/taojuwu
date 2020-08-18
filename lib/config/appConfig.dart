class AppConfig {
  static bool isPro = bool.fromEnvironment('dart.vm.product');
  static String get baseUrl =>
      isPro ? 'https://example.com/v1' : 'https://dev.example.com/v1';
}
