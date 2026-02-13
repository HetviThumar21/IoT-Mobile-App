import 'dart:developer';

enum Environment { TESTING, LIVE }

class AppConfig {
  static Environment environment = Environment.TESTING;
  // static String basicAuth = 'bW95ZW1veWU=';
  static  String appVersion = "1";

  static String get baseUrl {
    switch (environment) {
      case Environment.TESTING:
        return 'https://172.20.10.2:8021/api/auth';
      case Environment.LIVE:
        return 'https://makesure.org:8018/api/';
    }
  }

  static String getFormattedUrl(String endpoint) {
    final fullUrl = '$baseUrl$endpoint';
    log('Formatted URL: $fullUrl');
    return fullUrl;
  }
}
