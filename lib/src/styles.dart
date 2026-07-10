/// Predefined Intaleq Map tile style URLs.
class IntaleqStyles {
  IntaleqStyles._();

  /// Dark premium Obsidian style — the Intaleq default.
  ///
  /// This style is optimized for readability and a premium look.
  static String obsidian(String apiKey) =>
      'https://map-saas.intaleqapp.com/api/maps/style.json?theme=obsidian&api_key=$apiKey';

  /// High-contrast light style.
  ///
  /// Best for daylight use and printing.
  static String light(String apiKey) =>
      'https://map-saas.intaleqapp.com/api/maps/style.json?theme=light&api_key=$apiKey';

  /// Satellite imagery with road labels.
  ///
  /// High-resolution satellite tiles overlaid with Intaleq vector labels.
  static String satellite(String apiKey) =>
      'https://map-saas.intaleqapp.com/api/maps/style.json?theme=satellite&api_key=$apiKey';

  /// Path to the local light style asset.
  static const String localLight = 'assets/style.json';

  /// Path to the local dark style asset.
  static const String localDark = 'assets/style_dark.json';
}
