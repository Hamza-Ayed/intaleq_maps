import 'dart:ui';
import 'package:maplibre_gl/maplibre_gl.dart' as maplibre;
import '../constants/colors.dart';

class MarkerOptions {
  final maplibre.LatLng position;
  final String? iconImage;
  final double? iconSize;
  final double? iconRotate;
  final String? textField;
  final double? textOffset;

  MarkerOptions({
    required this.position,
    this.iconImage,
    this.iconSize,
    this.iconRotate,
    this.textField,
    this.textOffset,
  });

  maplibre.SymbolOptions toSymbolOptions() {
    return maplibre.SymbolOptions(
      geometry: position,
      iconImage: iconImage,
      iconSize: iconSize,
      iconRotate: iconRotate,
      textField: textField,
      textOffset: textOffset != null ? Offset(0, textOffset!) : null,
    );
  }
}

class PolylineOptions {
  final List<maplibre.LatLng> coordinates;
  final String? color;
  final double? width;
  final double? opacity;

  PolylineOptions({
    required this.coordinates,
    this.color,
    this.width,
    this.opacity,
  });

  maplibre.LineOptions toLineOptions() {
    return maplibre.LineOptions(
      geometry: coordinates,
      lineColor: color ?? IntaleqColors.primaryBlue,
      lineWidth: width ?? 5.0,
      lineOpacity: opacity ?? 1.0,
      lineJoin: 'round',
    );
  }
}

class CircleOptions {
  final maplibre.LatLng position;
  final double radius;
  final String? color;
  final double? opacity;
  final String? strokeColor;
  final double? strokeWidth;

  CircleOptions({
    required this.position,
    required this.radius,
    this.color,
    this.opacity,
    this.strokeColor,
    this.strokeWidth,
  });

  maplibre.CircleOptions toMapLibreOptions() {
    return maplibre.CircleOptions(
      geometry: position,
      circleRadius: radius,
      circleColor: color ?? IntaleqColors.primaryBlue,
      circleOpacity: opacity ?? 0.6,
      circleStrokeColor: strokeColor,
      circleStrokeWidth: strokeWidth,
    );
  }
}

class PolygonOptions {
  /// The list of rings. The first ring is the outer boundary, 
  /// and subsequent rings are holes.
  final List<List<maplibre.LatLng>> rings;
  final String? fillColor;
  final double? fillOpacity;
  final String? outlineColor;

  PolygonOptions({
    required this.rings,
    this.fillColor,
    this.fillOpacity,
    this.outlineColor,
  });

  maplibre.FillOptions toFillOptions() {
    return maplibre.FillOptions(
      geometry: rings,
      fillColor: fillColor ?? IntaleqColors.fillGray,
      fillOpacity: fillOpacity ?? 0.4,
      fillOutlineColor: outlineColor ?? IntaleqColors.primaryBlue,
    );
  }
}
