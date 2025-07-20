import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  static const String email = 'denversmurf01@gmail.com';
  static const String youtube = 'mailto:your_email@example.com';
  static const String instagram = 'mailto:your_email@example.com';
  static const String facebook = 'mailto:your_email@example.com';
  static const String twitter = 'mailto:your_email@example.com';

  static void launchEmail(String url) async {
    final Uri emailUri = Uri.parse(url);

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (kDebugMode) {
        print('Could not launch email app');
      }
    }
  }
}
