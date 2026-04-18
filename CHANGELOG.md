## 2.2.0

* Added `onStyleLoaded` callback to `IntaleqMap` to handle style initialization.
* Improved overlay persistence: Markers, Polylines, Circles, and Polygons are now automatically restored after style changes (e.g., toggling Dark Mode).
* Exported MapLibre offline management primitives (`OfflineRegion`, `downloadOfflineRegion`, etc.) for advanced usage.
* Exported `MyLocationRenderMode` and `MyLocationTrackingMode` for location UI customization.
* Fixed `trackCameraPosition` logic to correctly trigger `onCameraIdle`.

## 2.1.3

* Fixed missing `dart:ui` import in `types.dart`.
* Verified compatibility with Flutter 3.22.

## 2.1.2

* Updated dependencies to latest stable versions (`http`, `lints`, `meta`).
* Fixed `onCameraMoveStarted` not being triggered correctly.
* Updated `README.md` to reflect the latest version.

## 2.1.1

* Finalized static analysis and documentation fixes for maximum pub.dev score.
* Renamed deprecated MapLibre components to latest naming conventions.
* Fixed deprecated Color member usage.

## 2.1.0

* Fixed static analysis warnings (unused imports and variables).
* Added comprehensive documentation for core SDK elements.
* Improved API parity with Google Maps Flutter (CameraPosition helpers).
* Added an `example/` project demonstrating SDK integration.

## 2.0.0

**Breaking redesign — full Google Maps Flutter API parity.**

* Replaced imperative `add/removeMarker()` controller methods with a
  **declarative `Set<Marker>` / `Set<Polyline>` / `Set<Circle>` / `Set<Polygon>`**
  API on the widget, identical to `google_maps_flutter`.
* Added `MarkerId`, `PolylineId`, `CircleId`, `PolygonId` typed ID classes.
* Added per-object callbacks: `Marker.onTap`, `Marker.onDragEnd`, `Polyline.onTap`, etc.
* Added `InlqBitmap` (mirrors `BitmapDescriptor`): `defaultMarker`,
  `defaultMarkerWithHue`, `fromAsset`, `fromBytes`, `fromStyleImage`.
* Added `InfoWindow` model with `title`, `snippet`, and `onTap`.
* Added `IntaleqMapType` enum (`normal`, `light`, `satellite`, `none`).
* Added `MinMaxZoomPreference` and `CameraTargetBounds`.
* Renamed `getRoute()` → `getDirections()` for API clarity.
* Added `reverseGeocode()` to controller.
* Added `PolylineUtils.encode()` and `PolylineUtils.totalLength()`.
* Added `IntaleqColors` Flutter `Color` constants alongside hex strings.
* Removed `geolocator` and `get`/`latlong2` dependencies (no longer needed).

## 1.0.0

* Initial release. Imperative add/remove API over MapLibre GL.