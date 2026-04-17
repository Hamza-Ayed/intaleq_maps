/// Intaleq Maps SDK for Flutter.
///
/// A Google Maps Flutter-compatible API backed by MapLibre GL,
/// optimized for Jordan, Syria, and the broader MENA region.
library intaleq_maps;

// Re-export core MapLibre primitives under familiar names
export 'package:maplibre_gl/maplibre_gl.dart'
    show LatLng, LatLngBounds, CameraUpdate, CameraPosition;

// Public SDK surface
export 'src/intaleq_map_widget.dart';
export 'src/intaleq_map_controller.dart';
export 'src/styles.dart';
export 'src/constants/colors.dart';
export 'src/utils/polyline_utils.dart';

// Models — mirrors google_maps_flutter public types
export 'src/models/geometry.dart';
export 'src/models/bitmap.dart';
export 'src/models/info_window.dart';
export 'src/models/types.dart';
