import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'intaleq_map_controller.dart';
import 'styles.dart';

typedef MapCreatedCallback = void Function(IntaleqMapController controller);

class IntaleqMap extends StatefulWidget {
  final String apiKey;
  final String? styleUrl;
  final LatLng initialPosition;
  final double initialZoom;
  final MapCreatedCallback? onMapCreated;
  final bool myLocationEnabled;

  const IntaleqMap({
    super.key,
    required this.apiKey,
    this.styleUrl,
    this.initialPosition = const LatLng(33.5138, 36.2765),
    this.initialZoom = 14.0,
    this.onMapCreated,
    this.myLocationEnabled = false,
  });

  @override
  State<IntaleqMap> createState() => _IntaleqMapState();
}

class _IntaleqMapState extends State<IntaleqMap> {
  IntaleqMapController? _intaleqController;

  @override
  Widget build(BuildContext context) {
    final style = widget.styleUrl ?? IntaleqStyles.obsidian(widget.apiKey);

    return MaplibreMap(
      onMapCreated: (MaplibreMapController controller) {
        _intaleqController = IntaleqMapController(
          mapController: controller,
          apiKey: widget.apiKey,
        );
        if (widget.onMapCreated != null) {
          widget.onMapCreated!(_intaleqController!);
        }
      },
      styleString: style,
      initialCameraPosition: CameraPosition(
        target: widget.initialPosition,
        zoom: widget.initialZoom,
      ),
      myLocationEnabled: widget.myLocationEnabled,
      compassEnabled: false,
      trackCameraPosition: true,
    );
  }
}
