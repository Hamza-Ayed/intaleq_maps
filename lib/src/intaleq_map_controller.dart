import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart' hide CircleOptions;
import 'models/geometry.dart';

class IntaleqMapController {
  final MaplibreMapController mapController;
  final String apiKey;

  IntaleqMapController({
    required this.mapController,
    required this.apiKey,
  });

  // --- API Integrations ---

  /// Search for places using Intaleq Geocoding API
  Future<List<dynamic>> search(String query) async {
    final response = await http.get(
      Uri.parse('https://map-saas.intaleq.com/v1/geocoding/search?q=$query&key=$apiKey'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to search');
  }

  /// Get route using Intaleq Routing API
  Future<Map<String, dynamic>> getRoute(LatLng start, LatLng end, {String profile = 'driving'}) async {
    final response = await http.get(
      Uri.parse(
        'https://map-saas.intaleq.com/v1/routing/route?start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}&profile=$profile&key=$apiKey',
      ),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to fetch route');
  }

  // --- Friendly Abstractions (Transformation Layer) ---

  /// Add a marker (friendly wrapper for addSymbol)
  Future<Symbol> addMarker(MarkerOptions options) async {
    return await mapController.addSymbol(options.toSymbolOptions());
  }

  /// Add multiple markers
  Future<List<Symbol>> addMarkers(List<MarkerOptions> optionsList) async {
    final symbols = <Symbol>[];
    for (var options in optionsList) {
      symbols.add(await addMarker(options));
    }
    return symbols;
  }

  /// Remove a marker
  Future<void> removeMarker(Symbol marker) async {
    await mapController.removeSymbol(marker);
  }

  /// Add a polyline (friendly wrapper for addLine)
  Future<Line> addPolyline(PolylineOptions options) async {
    return await mapController.addLine(options.toLineOptions());
  }

  /// Remove a polyline
  Future<void> removePolyline(Line polyline) async {
    await mapController.removeLine(polyline);
  }

  /// Add a circle
  Future<Circle> addCircle(CircleOptions options) async {
    return await mapController.addCircle(options.toMapLibreOptions());
  }

  /// Remove a circle
  Future<void> removeCircle(Circle circle) async {
    await mapController.removeCircle(circle);
  }

  /// Add a polygon (Fill)
  Future<Fill> addPolygon(PolygonOptions options) async {
    return await mapController.addFill(options.toFillOptions());
  }

  /// Remove a polygon
  Future<void> removePolygon(Fill polygon) async {
    await mapController.removeFill(polygon);
  }

  /// Clear all map objects
  void clearAll() {
    mapController.clearSymbols();
    mapController.clearLines();
    mapController.clearCircles();
    mapController.clearFills();
  }

  // --- Camera Controls ---

  void animateCameraTo(LatLng position, {double? zoom}) {
    mapController.animateCamera(CameraUpdate.newLatLngZoom(position, zoom ?? mapController.cameraPosition?.zoom ?? 14.0));
  }
}
