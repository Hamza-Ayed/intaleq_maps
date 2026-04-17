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