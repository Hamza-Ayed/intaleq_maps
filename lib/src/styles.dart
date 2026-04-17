/// Predefined Intaleq Map tile style URLs.
class IntaleqStyles {
  IntaleqStyles._();

  /// Dark premium Obsidian style — the Intaleq default.
  static String obsidian(String apiKey) =>
      'https://maps.intaleq.com/styles/obsidian/style.json?key=$apiKey';

  /// High-contrast light style.
  static String light(String apiKey) =>
      'https://maps.intaleq.com/styles/light/style.json?key=$apiKey';

  /// Satellite imagery with road labels.
  static String satellite(String apiKey) =>
      'https://maps.intaleq.com/styles/satellite/style.json?key=$apiKey';
}
