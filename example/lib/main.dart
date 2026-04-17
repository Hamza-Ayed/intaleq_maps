import 'package:flutter/material.dart';
import 'package:intaleq_maps/intaleq_maps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intaleq Maps Example',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  IntaleqMapController? _controller;

  // Example marker
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('damascus'),
      position: LatLng(33.5138, 36.2765),
      infoWindow: InfoWindow(
        title: 'Damascus',
        snippet: 'The oldest continuously inhabited city.',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intaleq Maps Demo'),
      ),
      body: IntaleqMap(
        apiKey: 'YOUR_API_KEY_HERE', // Replace with a valid key
        initialCameraPosition: const CameraPosition(
          target: LatLng(33.5138, 36.2765),
          zoom: 12,
        ),
        markers: _markers,
        onCameraMoveStarted: () {
          debugPrint('Camera movement started');
        },
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller?.animateCamera(
            CameraUpdate.newLatLngZoom(const LatLng(31.9454, 35.9284), 12),
          );
        },
        child: const Icon(Icons.location_city),
      ),
    );
  }
}
