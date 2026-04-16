# Intaleq Maps SDK for Flutter

A premium Flutter SDK for the Intaleq Map Platform, optimized for Jordan, Syria, and the broader region. This SDK provides a simplified, developer-friendly interface over MapLibre GL, with built-in support for Intaleq's Routing and Geocoding APIs.

## Features

- **Simplified Geometry**: Use `Marker`, `Polyline`, `Circle`, and `Polygon` (with hole support) instead of complex low-level types.
- **Intaleq Routing**: Integrated multi-profile routing API.
- **Intaleq Geocoding**: High-performance place search and reverse geocoding.
- **Branding-Ready**: Built-in Intaleq branding colors and premium map styles (Obsidian, Light, Satellite).
- **Standalone**: No external dependencies required for route decoding.

## Getting Started

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  intaleq_maps: ^1.0.0
```

## Usage

### Initialize the Map

```dart
IntaleqMap(
  apiKey: "YOUR_INTALEQ_API_KEY",
  onMapCreated: (controller) {
    // Access the controller here
  },
)
```

### Add a Marker

```dart
await controller.addMarker(MarkerOptions(
  position: LatLng(33.5138, 36.2765),
  iconImage: "marker-icon",
));
```

### Get a Route

```dart
final routeData = await controller.getRoute(
  LatLng(33.5138, 36.2765),
  LatLng(33.5, 36.3),
);
```

## Documentation

For full documentation and API reference, visit [intaleqapp.com](https://intaleqapp.com).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
