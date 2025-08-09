import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  static const String email = 'almaerifa1234@gmail.com';
  static const String youtube = 'mailto:your_email@example.com';
  static const String instagram = 'mailto:your_email@example.com';
  static const String facebook = 'mailto:your_email@example.com';
  static const String twitter = 'mailto:your_email@example.com';

  static Future<void> launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'التواصل معنا', 'body': 'مرحباً،'},
    );

    try {
      final bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication, // ⚠️ حیاتی
      );

      if (!launched) {
        throw 'Launch returned false';
      }
    } catch (e) {
      print('Error launching email: $e');
    }
  }
}
