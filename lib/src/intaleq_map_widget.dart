import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart' as mgl;
import 'intaleq_map_controller.dart';
import 'styles.dart';
import 'models/geometry.dart';
import 'models/types.dart';

/// A widget displaying an Intaleq map.
///
/// ## Drop-in replacement for `GoogleMap`
///
/// ```dart
/// // Before (Google Maps Flutter)
/// GoogleMap(
///   initialCameraPosition: CameraPosition(target: LatLng(33.5, 36.2), zoom: 14),
///   markers: _markers,
///   onMapCreated: (ctrl) => _controller = ctrl,
/// )
///
/// // After (Intaleq Maps)
/// IntaleqMap(
///   apiKey: 'YOUR_KEY',
///   initialCameraPosition: CameraPosition(target: LatLng(33.5, 36.2), zoom: 14),
///   markers: _markers,
///   onMapCreated: (ctrl) => _controller = ctrl,
/// )
/// ```
///
/// All overlay collections ([markers], [polylines], [circles], [polygons])
/// are **declarative**: just call `setState` with a new `Set` and the map
/// will reconcile additions, updates, and removals automatically.
class IntaleqMap extends StatefulWidget {
  const IntaleqMap({
    super.key,
    required this.apiKey,
    required this.initialCameraPosition,
    this.mapType = IntaleqMapType.normal,
    this.styleUrl,
    this.markers = const {},
    this.polylines = const {},
    this.circles = const {},
    this.polygons = const {},
    this.onMapCreated,
    this.onTap,
    this.onLongPress,
    this.onCameraMove,
    this.onCameraMoveStarted,
    this.onCameraIdle,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.zoomControlsEnabled = false,
    this.compassEnabled = false,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
  });

  // ── Required ───────────────────────────────────────────────

  /// Your Intaleq Maps API key.
  final String apiKey;

  /// Starting camera position (target + zoom).
  final mgl.CameraPosition initialCameraPosition;

  // ── Map style ──────────────────────────────────────────────

  /// Base tile style. Ignored when [styleUrl] is provided.
  final IntaleqMapType mapType;

  /// Override with a custom MapLibre style URL.
  final String? styleUrl;

  // ── Overlays (declarative — mirrors GoogleMap) ─────────────

  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final Set<Polygon> polygons;

  // ── Lifecycle callbacks ────────────────────────────────────

  /// Called once the map is ready. Use [IntaleqMapController] for all operations.
  final MapCreatedCallback? onMapCreated;

  // ── Interaction callbacks ──────────────────────────────────

  /// Called when the user taps the map (not on a marker).
  final ArgumentCallback<mgl.LatLng>? onTap;

  /// Called on a long-press on the map.
  final ArgumentCallback<mgl.LatLng>? onLongPress;

  /// Called repeatedly while the camera is moving.
  final CameraPositionCallback? onCameraMove;

  /// Called when the camera starts moving.
  final VoidCallback? onCameraMoveStarted;

  /// Called when the camera becomes idle.
  final VoidCallback? onCameraIdle;

  // ── UI controls ────────────────────────────────────────────

  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomControlsEnabled;
  final bool compassEnabled;

  // ── Gesture controls ───────────────────────────────────────

  final bool rotateGesturesEnabled;
  final bool scrollGesturesEnabled;
  final bool tiltGesturesEnabled;
  final bool zoomGesturesEnabled;

  // ── Camera constraints ─────────────────────────────────────

  final MinMaxZoomPreference minMaxZoomPreference;
  final CameraTargetBounds cameraTargetBounds;

  @override
  State<IntaleqMap> createState() => _IntaleqMapState();
}

class _IntaleqMapState extends State<IntaleqMap> {
  IntaleqMapController? _controller;

  @override
  void didUpdateWidget(IntaleqMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ctrl = _controller;
    if (ctrl == null) return;

    // Reconcile each overlay set when widget rebuilds.
    ctrl.diffMarkers(oldWidget.markers, widget.markers);
    ctrl.diffPolylines(oldWidget.polylines, widget.polylines);
    ctrl.diffCircles(oldWidget.circles, widget.circles);
    ctrl.diffPolygons(oldWidget.polygons, widget.polygons);
  }

  String get _resolvedStyleUrl {
    if (widget.styleUrl != null) return widget.styleUrl!;
    return switch (widget.mapType) {
      IntaleqMapType.normal => IntaleqStyles.obsidian(widget.apiKey),
      IntaleqMapType.light => IntaleqStyles.light(widget.apiKey),
      IntaleqMapType.satellite => IntaleqStyles.satellite(widget.apiKey),
      IntaleqMapType.none => 'about:blank',
    };
  }

  Future<void> _onMapCreated(mgl.MaplibreMapController rawCtrl) async {
    // Wire up tap routing before handing the controller to the caller.
    rawCtrl.onSymbolTapped.add(_onSymbolTapped);
    rawCtrl.onLineTapped.add(_onLineTapped);

    final ctrl = await IntaleqMapController.create(
      raw: rawCtrl,
      apiKey: widget.apiKey,
    );
    _controller = ctrl;

    // Render the initial overlay sets.
    for (final m in widget.markers) await ctrl.addMarker(m);
    for (final p in widget.polylines) await ctrl.addPolyline(p);
    for (final c in widget.circles) await ctrl.addCircle(c);
    for (final g in widget.polygons) await ctrl.addPolygon(g);

    widget.onMapCreated?.call(ctrl);
  }

  void _onSymbolTapped(mgl.Symbol symbol) =>
      _controller?.onSymbolTapped(symbol);

  void _onLineTapped(mgl.Line line) => _controller?.onLineTapped(line);

  @override
  Widget build(BuildContext context) {
    return mgl.MaplibreMap(
      styleString: _resolvedStyleUrl,
      initialCameraPosition: widget.initialCameraPosition,
      onMapCreated: _onMapCreated,
      onMapClick: widget.onTap != null
          ? (point, latlng) => widget.onTap!(latlng)
          : null,
      onMapLongClick: widget.onLongPress != null
          ? (point, latlng) => widget.onLongPress!(latlng)
          : null,
      onCameraIdle: widget.onCameraIdle,
      onCameraTrackingChanged: null,
      myLocationEnabled: widget.myLocationEnabled,
      myLocationRenderMode: widget.myLocationEnabled
          ? mgl.MyLocationRenderMode.NORMAL
          : mgl.MyLocationRenderMode.NORMAL,
      myLocationTrackingMode: mgl.MyLocationTrackingMode.None,
      compassEnabled: widget.compassEnabled,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      scrollGesturesEnabled: widget.scrollGesturesEnabled,
      tiltGesturesEnabled: widget.tiltGesturesEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
      minMaxZoomPreference: mgl.MinMaxZoomPreference(
        widget.minMaxZoomPreference.minZoom,
        widget.minMaxZoomPreference.maxZoom,
      ),
      cameraTargetBounds: widget.cameraTargetBounds.bounds != null
          ? mgl.CameraTargetBounds(widget.cameraTargetBounds.bounds!)
          : mgl.CameraTargetBounds.unbounded,
      trackCameraPosition: widget.onCameraMove != null,
      onCameraTrackingDismissed: null,
    );
  }
}
