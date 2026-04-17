# Intaleq Maps SDK for Flutter

A **drop-in replacement for `google_maps_flutter`** backed by MapLibre GL, optimized for Jordan, Syria, and the broader MENA region.

---

## Why Intaleq Maps?

| Feature | `google_maps_flutter` | `intaleq_maps` |
|---|---|---|
| Works in Syria (sanctions) | ❌ | ✅ |
| Self-hosted tiles | ❌ | ✅ |
| MENA-optimised data | ❌ | ✅ |
| Same Flutter API | — | ✅ |
| Offline-ready styles | ❌ | ✅ |

---

## Installation

```yaml
dependencies:
  intaleq_maps: ^2.0.0
```

---

## Migration from `google_maps_flutter`

The API is intentionally identical. Most migrations are a find-and-replace:

| Google | Intaleq |
|---|---|
| `GoogleMap(…)` | `IntaleqMap(apiKey: key, …)` |
| `GoogleMapController` | `IntaleqMapController` |
| `BitmapDescriptor` | `InlqBitmap` |
| `MapType.normal` | `IntaleqMapType.normal` |

Everything else — `Marker`, `Polyline`, `Circle`, `Polygon`, `MarkerId`, `PolylineId`, `InfoWindow`, `CameraUpdate`, `LatLng`, `LatLngBounds` — is **identical**.

---

## Usage

### Basic map

```dart
IntaleqMap(
  apiKey: 'YOUR_INTALEQ_API_KEY',
  initialCameraPosition: CameraPosition(
    target: LatLng(33.5138, 36.2765), // Damascus
    zoom: 14,
  ),
  onMapCreated: (IntaleqMapController controller) {
    _controller = controller;
  },
)
```

### Declarative markers (exactly like Google Maps Flutter)

```dart
// In your State:
Set<Marker> _markers = {};

// Add a marker — just setState:
setState(() {
  _markers = {
    Marker(
      markerId: MarkerId('driver_1'),
      position: LatLng(33.5138, 36.2765),
      icon: InlqBitmap.fromAsset('assets/icons/car.png'),
      infoWindow: InfoWindow(
        title: 'Ahmad',
        snippet: 'Toyota Corolla · 3 min away',
      ),
      onTap: () => print('driver tapped'),
    ),
  };
});

// Pass to widget:
IntaleqMap(
  apiKey: _apiKey,
  initialCameraPosition: _camera,
  markers: _markers,       // ← declarative
  polylines: _polylines,   // ← declarative
  circles: _circles,       // ← declarative
  polygons: _polygons,     // ← declarative
)
```

### Camera control

```dart
// Animate to a position
_controller.animateCamera(
  CameraUpdate.newLatLngZoom(LatLng(33.5, 36.2), 15),
);

// Fit bounds
_controller.animateCamera(
  CameraUpdate.newLatLngBounds(bounds, left: 50, right: 50, top: 100, bottom: 100),
);
```

### Get a route

```dart
final route = await _controller.getDirections(
  LatLng(33.5138, 36.2765),
  LatLng(33.49, 36.30),
  profile: 'driving',
);

// Decode the encoded polyline from the response
final points = PolylineUtils.decode(route['geometry']);

setState(() {
  _polylines = {
    Polyline(
      polylineId: PolylineId('route'),
      points: points,
      color: IntaleqColors.routeCyan,
      width: 5,
    ),
  };
});
```

### Search for places

```dart
final results = await _controller.searchPlaces('مطار دمشق');
```

### Map types

```dart
IntaleqMap(
  mapType: IntaleqMapType.normal,    // Dark Obsidian (default)
  // mapType: IntaleqMapType.light,
  // mapType: IntaleqMapType.satellite,
  ...
)
```

---

## API Reference

### `IntaleqMap` widget

| Property | Type | Default | Description |
|---|---|---|---|
| `apiKey` | `String` | required | Your Intaleq Maps API key |
| `initialCameraPosition` | `CameraPosition` | required | Starting camera |
| `markers` | `Set<Marker>` | `{}` | Declarative marker set |
| `polylines` | `Set<Polyline>` | `{}` | Declarative polyline set |
| `circles` | `Set<Circle>` | `{}` | Declarative circle set |
| `polygons` | `Set<Polygon>` | `{}` | Declarative polygon set |
| `onMapCreated` | `MapCreatedCallback?` | — | Fires once map is ready |
| `onTap` | `ArgumentCallback<LatLng>?` | — | Map tap |
| `onLongPress` | `ArgumentCallback<LatLng>?` | — | Map long press |
| `onCameraMove` | `CameraPositionCallback?` | — | Camera movement |
| `mapType` | `IntaleqMapType` | `.normal` | Tile style |
| `myLocationEnabled` | `bool` | `false` | Show user location dot |

### `IntaleqMapController`

| Method | Description |
|---|---|
| `animateCamera(update)` | Animated camera move |
| `moveCamera(update)` | Instant camera move |
| `getZoomLevel()` | Current zoom level |
| `getVisibleRegion()` | Current `LatLngBounds` |
| `clearOverlays()` | Remove all markers/lines/circles/polygons |
| `getDirections(origin, dest)` | Intaleq Routing API |
| `searchPlaces(query)` | Intaleq Geocoding API |
| `reverseGeocode(position)` | Reverse geocoding |
| `addImage(id, bytes)` | Register custom marker image |

---

## License

MIT — see [LICENSE](LICENSE).