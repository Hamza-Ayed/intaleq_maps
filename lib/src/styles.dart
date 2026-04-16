class IntaleqStyles {
  /// Dark premium map style (The default for Intaleq)
  static String obsidian(String apiKey) =>
      'https://maps.intaleq.com/styles/obsidian/style.json?key=$apiKey';

  /// Light premium map style
  static String light(String apiKey) =>
      'https://maps.intaleq.com/styles/light/style.json?key=$apiKey';

  /// Satellite hybrid style
  static String satellite(String apiKey) =>
      'https://maps.intaleq.com/styles/satellite/style.json?key=$apiKey';
}
