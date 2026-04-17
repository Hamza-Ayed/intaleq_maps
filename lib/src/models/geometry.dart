import 'dart:ui' show Offset, Color;
import 'package:flutter/foundation.dart' show VoidCallback, ValueChanged;
import 'package:maplibre_gl/maplibre_gl.dart' as mgl;
import 'bitmap.dart';
import 'info_window.dart';

// ─────────────────────────────────────────────────────────────
// ID types  (identical contract to google_maps_flutter)
// ─────────────────────────────────────────────────────────────

/// Uniquely identifies a [Marker] on the map.
class MarkerId {
  /// Creates a [MarkerId] with the given [value].
  const MarkerId(this.value);

  /// The unique string identifier.
  final String value;

  @override
  bool operator ==(Object o) => o is MarkerId && o.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'MarkerId($value)';
}

/// Uniquely identifies a [Polyline] on the map.
class PolylineId {
  /// Creates a [PolylineId] with the given [value].
  const PolylineId(this.value);

  /// The unique string identifier.
  final String value;

  @override
  bool operator ==(Object o) => o is PolylineId && o.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'PolylineId($value)';
}

/// Uniquely identifies a [Circle] on the map.
class CircleId {
  /// Creates a [CircleId] with the given [value].
  const CircleId(this.value);

  /// The unique string identifier.
  final String value;

  @override
  bool operator ==(Object o) => o is CircleId && o.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'CircleId($value)';
}

/// Uniquely identifies a [Polygon] on the map.
class PolygonId {
  /// Creates a [PolygonId] with the given [value].
  const PolygonId(this.value);

  /// The unique string identifier.
  final String value;

  @override
  bool operator ==(Object o) => o is PolygonId && o.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'PolygonId($value)';
}

// ─────────────────────────────────────────────────────────────
// Marker  (mirrors google_maps_flutter Marker)
// ─────────────────────────────────────────────────────────────

/// A marker that is placed at a specific geographical location on the map.
class Marker {
  /// Creates a [Marker].
  const Marker({
    required this.markerId,
    required this.position,
    this.alpha = 1.0,
    this.anchor = const Offset(0.5, 1.0),
    this.draggable = false,
    this.flat = false,
    this.icon = InlqBitmap.defaultMarker,
    this.infoWindow = InfoWindow.noText,
    this.rotation = 0.0,
    this.visible = true,
    this.zIndex = 0.0,
    this.onTap,
    this.onDragStart,
    this.onDrag,
    this.onDragEnd,
  });

  /// Unique identifier for this marker.
  final MarkerId markerId;

  /// Geographical location of the marker.
  final mgl.LatLng position;

  /// Opacity of the marker icon, from 0.0 (transparent) to 1.0 (opaque).
  final double alpha;

  /// Icon anchor point as a fraction of icon size. (0.5, 1.0) = bottom-center.
  final Offset anchor;

  /// Whether the marker can be dragged by the user.
  final bool draggable;

  /// When true the marker is drawn flat against the map surface.
  final bool flat;

  /// The icon image for the marker.
  final InlqBitmap icon;

  /// Info window shown when the marker is tapped.
  final InfoWindow infoWindow;

  /// Rotation of the marker in degrees clockwise from north.
  final double rotation;

  /// Whether the marker is visible on the map.
  final bool visible;

  /// Z-index for draw ordering among markers.
  final double zIndex;

  /// Called when the marker is tapped.
  final VoidCallback? onTap;

  /// Called when a drag starts.
  final ValueChanged<mgl.LatLng>? onDragStart;

  /// Called repeatedly during drag.
  final ValueChanged<mgl.LatLng>? onDrag;

  /// Called when drag ends.
  final ValueChanged<mgl.LatLng>? onDragEnd;

  Marker copyWith({
    mgl.LatLng? position,
    double? alpha,
    Offset? anchor,
    bool? draggable,
    bool? flat,
    InlqBitmap? icon,
    InfoWindow? infoWindow,
    double? rotation,
    bool? visible,
    double? zIndex,
    VoidCallback? onTap,
    ValueChanged<mgl.LatLng>? onDragStart,
    ValueChanged<mgl.LatLng>? onDrag,
    ValueChanged<mgl.LatLng>? onDragEnd,
  }) {
    return Marker(
      markerId: markerId,
      position: position ?? this.position,
      alpha: alpha ?? this.alpha,
      anchor: anchor ?? this.anchor,
      draggable: draggable ?? this.draggable,
      flat: flat ?? this.flat,
      icon: icon ?? this.icon,
      infoWindow: infoWindow ?? this.infoWindow,
      rotation: rotation ?? this.rotation,
      visible: visible ?? this.visible,
      zIndex: zIndex ?? this.zIndex,
      onTap: onTap ?? this.onTap,
      onDragStart: onDragStart ?? this.onDragStart,
      onDrag: onDrag ?? this.onDrag,
      onDragEnd: onDragEnd ?? this.onDragEnd,
    );
  }

  /// Internal: converts to MapLibre SymbolOptions.
  mgl.SymbolOptions toSymbolOptions() {
    return mgl.SymbolOptions(
      geometry: position,
      iconImage: icon.mapLibreImageId,
      iconSize: icon.size,
      iconRotate: rotation,
      iconOpacity: alpha,
      iconAnchor: _anchorToString(anchor),
      draggable: draggable,
      zIndex: zIndex.toInt(),
      textField: infoWindow.title,
    );
  }

  static String _anchorToString(Offset anchor) {
    if (anchor.dx == 0.5 && anchor.dy == 1.0) return 'bottom';
    if (anchor.dx == 0.5 && anchor.dy == 0.0) return 'top';
    if (anchor.dx == 0.0 && anchor.dy == 0.5) return 'left';
    if (anchor.dx == 1.0 && anchor.dy == 0.5) return 'right';
    if (anchor.dx == 0.5 && anchor.dy == 0.5) return 'center';
    return 'bottom';
  }

  @override
  bool operator ==(Object o) => o is Marker && o.markerId == markerId;
  @override
  int get hashCode => markerId.hashCode;
}

// ─────────────────────────────────────────────────────────────
// Polyline  (mirrors google_maps_flutter Polyline)
// ─────────────────────────────────────────────────────────────

/// A polyline is a list of segments that join a sequence of [mgl.LatLng] locations.
class Polyline {
  /// Creates a [Polyline].
  const Polyline({
    required this.polylineId,
    required this.points,
    this.color = const Color(0xFF0D47A1),
    this.width = 5,
    this.visible = true,
    this.zIndex = 0,
    this.geodesic = false,
    this.onTap,
  });

  /// Unique identifier for this polyline.
  final PolylineId polylineId;

  /// The ordered list of points that make up the polyline.
  final List<mgl.LatLng> points;

  /// Line stroke color.
  final Color color;

  /// Line stroke width in screen pixels.
  final int width;

  /// Whether the polyline is visible on the map.
  final bool visible;

  final int zIndex;

  /// When true, the polyline follows the curvature of the Earth.
  final bool geodesic;

  /// Called when the polyline is tapped.
  final VoidCallback? onTap;

  Polyline copyWith({
    List<mgl.LatLng>? points,
    Color? color,
    int? width,
    bool? visible,
    int? zIndex,
    bool? geodesic,
    VoidCallback? onTap,
  }) {
    return Polyline(
      polylineId: polylineId,
      points: points ?? this.points,
      color: color ?? this.color,
      width: width ?? this.width,
      visible: visible ?? this.visible,
      zIndex: zIndex ?? this.zIndex,
      geodesic: geodesic ?? this.geodesic,
      onTap: onTap ?? this.onTap,
    );
  }

  /// Internal: converts to MapLibre LineOptions.
  mgl.LineOptions toLineOptions() {
    return mgl.LineOptions(
      geometry: points,
      lineColor: _colorToHex(color),
      lineWidth: width.toDouble(),
      lineOpacity: visible ? color.a : 0.0,
      lineJoin: 'round',
    );
  }

  @override
  bool operator ==(Object o) => o is Polyline && o.polylineId == polylineId;
  @override
  int get hashCode => polylineId.hashCode;
}

// ─────────────────────────────────────────────────────────────
// Circle  (mirrors google_maps_flutter Circle)
// ─────────────────────────────────────────────────────────────

/// A circle on the map surface.
class Circle {
  /// Creates a [Circle].
  const Circle({
    required this.circleId,
    required this.center,
    required this.radius,
    this.fillColor = const Color(0x1A0D47A1),
    this.strokeColor = const Color(0xFF0D47A1),
    this.strokeWidth = 2,
    this.visible = true,
    this.zIndex = 0,
    this.onTap,
  });

  /// Unique identifier for this circle.
  final CircleId circleId;

  /// Center of the circle.
  final mgl.LatLng center;

  /// Radius in meters.
  final double radius;

  /// Fill color (with alpha for opacity).
  final Color fillColor;

  /// Stroke color.
  final Color strokeColor;

  /// Stroke width in pixels.
  final int strokeWidth;

  final bool visible;
  final int zIndex;

  /// Called when the circle is tapped.
  final VoidCallback? onTap;

  Circle copyWith({
    mgl.LatLng? center,
    double? radius,
    Color? fillColor,
    Color? strokeColor,
    int? strokeWidth,
    bool? visible,
    int? zIndex,
    VoidCallback? onTap,
  }) {
    return Circle(
      circleId: circleId,
      center: center ?? this.center,
      radius: radius ?? this.radius,
      fillColor: fillColor ?? this.fillColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      visible: visible ?? this.visible,
      zIndex: zIndex ?? this.zIndex,
      onTap: onTap ?? this.onTap,
    );
  }

  /// Internal: converts to MapLibre CircleOptions.
  /// Note: MapLibre circle radius is in pixels, not meters. For a true
  /// meter-accurate circle, use [IntaleqMapController.addCircleAccurate].
  mgl.CircleOptions toCircleOptions() {
    return mgl.CircleOptions(
      geometry: center,
      circleRadius:
          radius / 10, // approximate; use addCircleAccurate for precision
      circleColor: _colorToHex(fillColor),
      circleOpacity: visible ? fillColor.a : 0.0,
      circleStrokeColor: _colorToHex(strokeColor),
      circleStrokeWidth: strokeWidth.toDouble(),
      circleStrokeOpacity: visible ? strokeColor.a : 0.0,
    );
  }

  @override
  bool operator ==(Object o) => o is Circle && o.circleId == circleId;
  @override
  int get hashCode => circleId.hashCode;
}

// ─────────────────────────────────────────────────────────────
// Polygon  (mirrors google_maps_flutter Polygon)
// ─────────────────────────────────────────────────────────────

/// A polygon on the map surface.
class Polygon {
  /// Creates a [Polygon].
  const Polygon({
    required this.polygonId,
    required this.points,
    this.holes = const [],
    this.fillColor = const Color(0x1ABDBDBD),
    this.strokeColor = const Color(0xFF0D47A1),
    this.strokeWidth = 2,
    this.visible = true,
    this.zIndex = 0,
    this.geodesic = false,
    this.onTap,
  });

  /// Unique identifier for this polygon.
  final PolygonId polygonId;

  /// Outer boundary of the polygon.
  final List<mgl.LatLng> points;

  /// Holes inside the polygon (each is a list of LatLng).
  final List<List<mgl.LatLng>> holes;

  /// Fill color.
  final Color fillColor;

  /// Outline stroke color.
  final Color strokeColor;

  /// Outline stroke width in pixels.
  final int strokeWidth;

  final bool visible;
  final int zIndex;
  final bool geodesic;

  /// Called when the polygon is tapped.
  final VoidCallback? onTap;

  Polygon copyWith({
    List<mgl.LatLng>? points,
    List<List<mgl.LatLng>>? holes,
    Color? fillColor,
    Color? strokeColor,
    int? strokeWidth,
    bool? visible,
    int? zIndex,
    bool? geodesic,
    VoidCallback? onTap,
  }) {
    return Polygon(
      polygonId: polygonId,
      points: points ?? this.points,
      holes: holes ?? this.holes,
      fillColor: fillColor ?? this.fillColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      visible: visible ?? this.visible,
      zIndex: zIndex ?? this.zIndex,
      geodesic: geodesic ?? this.geodesic,
      onTap: onTap ?? this.onTap,
    );
  }

  /// Internal: converts to MapLibre FillOptions.
  /// The first ring is the outer boundary; subsequent rings are holes.
  mgl.FillOptions toFillOptions() {
    final rings = [points, ...holes];
    return mgl.FillOptions(
      geometry: rings,
      fillColor: _colorToHex(fillColor),
      fillOpacity: visible ? fillColor.a : 0.0,
      fillOutlineColor: _colorToHex(strokeColor),
    );
  }

  @override
  bool operator ==(Object o) => o is Polygon && o.polygonId == polygonId;
  @override
  int get hashCode => polygonId.hashCode;
}

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

/// Converts a Flutter [Color] to a CSS hex string (e.g. '#0D47A1').
String _colorToHex(Color color) {
  return '#${(color.r * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(color.g * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(color.b * 255).round().toRadixString(16).padLeft(2, '0')}';
}
