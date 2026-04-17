import 'package:maplibre_gl/maplibre_gl.dart' as mgl;
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

  final mgl.LatLngBounds? bounds;

  /// Unbounded (default).
  static const CameraTargetBounds unbounded = CameraTargetBounds(null);

  @override
  String toString() => 'CameraTargetBounds($bounds)';
}

// ─────────────────────────────────────────────────────────────
// Typedefs  (same names as google_maps_flutter)
// ─────────────────────────────────────────────────────────────

/// Callback when the map is created.
typedef MapCreatedCallback = void Function(IntaleqMapController controller);

/// Generic callback for an argument of type [T].
typedef ArgumentCallback<T> = void Function(T argument);

/// Callback for camera position changes.
typedef CameraPositionCallback = void Function(CameraPosition position);

/// Defines a particular camera position.
///
/// This class mirrors `CameraPosition` from `google_maps_flutter`.
class CameraPosition {
  /// Creates an immutable representation of the [CameraPosition].
  const CameraPosition({
    required this.target,
    this.bearing = 0.0,
    this.tilt = 0.0,
    this.zoom = 0.0,
  });

  /// The location that the camera is pointing at.
  final mgl.LatLng target;

  /// The direction that the camera is facing in degrees clockwise from north.
  final double bearing;

  /// The angle, in degrees, of the camera angle from the perpendicular to the map's surface.
  final double tilt;

  /// The zoom level of the camera.
  final double zoom;

  /// Serializes this [CameraPosition] to a JSON-compatible map.
  Map<String, dynamic> toMap() {
    return {
      'target': [target.latitude, target.longitude],
      'bearing': bearing,
      'tilt': tilt,
      'zoom': zoom,
    };
  }

  /// Deserializes a [CameraPosition] from a map.
  static CameraPosition fromMap(Map<String, dynamic> json) {
    final targetList = json['target'] as List<dynamic>;
    return CameraPosition(
      target: mgl.LatLng(targetList[0] as double, targetList[1] as double),
      bearing: (json['bearing'] as num).toDouble(),
      tilt: (json['tilt'] as num).toDouble(),
      zoom: (json['zoom'] as num).toDouble(),
    );
  }

  /// Internal: Converts to MapLibre's [mgl.CameraPosition].
  mgl.CameraPosition toMapLibre() {
    return mgl.CameraPosition(
      target: target,
      bearing: bearing,
      tilt: tilt,
      zoom: zoom,
    );
  }

  /// Internal: Creates from MapLibre's [mgl.CameraPosition].
  static CameraPosition fromMapLibre(mgl.CameraPosition pos) {
    return CameraPosition(
      target: pos.target,
      bearing: pos.bearing,
      tilt: pos.tilt,
      zoom: pos.zoom,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CameraPosition) return false;
    return target == other.target &&
        bearing == other.bearing &&
        tilt == other.tilt &&
        zoom == other.zoom;
  }

  @override
  int get hashCode => Object.hash(target, bearing, tilt, zoom);

  @override
  String toString() =>
      'CameraPosition(target: $target, zoom: $zoom, bearing: $bearing, tilt: $tilt)';
}
