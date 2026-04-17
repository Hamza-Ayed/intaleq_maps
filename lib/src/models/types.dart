import 'package:maplibre_gl/maplibre_gl.dart'
    show LatLngBounds, LatLng, CameraPosition;
import '../intaleq_map_controller.dart';

// ─────────────────────────────────────────────────────────────
// IntaleqMapType  (mirrors MapType in google_maps_flutter)
// ─────────────────────────────────────────────────────────────

/// The visual style of the base map tiles.
enum IntaleqMapType {
  /// No base map tiles.
  none,

  /// Dark premium Obsidian style — the Intaleq default.
  normal,

  /// High-contrast light style.
  light,

  /// Satellite imagery with road labels overlaid.
  satellite,
}

// ─────────────────────────────────────────────────────────────
// MinMaxZoomPreference  (identical to google_maps_flutter)
// ─────────────────────────────────────────────────────────────

/// Preferred zoom level constraints for the camera.
class MinMaxZoomPreference {
  const MinMaxZoomPreference(this.minZoom, this.maxZoom);

  final double? minZoom;
  final double? maxZoom;

  /// Unbounded zoom (default).
  static const MinMaxZoomPreference unbounded =
      MinMaxZoomPreference(null, null);

  @override
  String toString() => 'MinMaxZoomPreference($minZoom, $maxZoom)';
}

// ─────────────────────────────────────────────────────────────
// CameraTargetBounds  (identical to google_maps_flutter)
// ─────────────────────────────────────────────────────────────

/// Constrains the camera target to a [LatLngBounds] region.
class CameraTargetBounds {
  const CameraTargetBounds(this.bounds);

  final LatLngBounds? bounds;

  /// Unbounded (default).
  static const CameraTargetBounds unbounded = CameraTargetBounds(null);

  @override
  String toString() => 'CameraTargetBounds($bounds)';
}

// ─────────────────────────────────────────────────────────────
// Typedefs  (same names as google_maps_flutter)
// ─────────────────────────────────────────────────────────────

typedef MapCreatedCallback = void Function(IntaleqMapController controller);
typedef ArgumentCallback<T> = void Function(T argument);
typedef CameraPositionCallback = void Function(CameraPosition position);
