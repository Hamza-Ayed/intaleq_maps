import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart' as mgl;
import 'intaleq_map_controller.dart';
import 'styles.dart';
import 'offline_service.dart';
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

    this.onLongPress,
    this.onMapCreated,
    this.onStyleLoaded,
    this.onTap,
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
    this.autoCache = true,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
  });

  // ── Required ───────────────────────────────────────────────

  /// Your Intaleq Maps API key.
  final String apiKey;

  /// Starting camera position (target + zoom).
  final CameraPosition initialCameraPosition;

  // ── Map style ──────────────────────────────────────────────

  /// Base tile style. Ignored when [styleUrl] is provided.
  final IntaleqMapType mapType;

  /// Override with a custom MapLibre style URL.
  final String? styleUrl;

  /// Automatically download tiles around the camera center when idle.
  final bool autoCache;

  // ── Overlays (declarative — mirrors GoogleMap) ─────────────

  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final Set<Polygon> polygons;

  // ── Lifecycle callbacks ────────────────────────────────────

  /// Called once the map is ready. Use [IntaleqMapController] for all operations.
  final MapCreatedCallback? onMapCreated;

  /// Note: If this callback returns a Future, the widget will await it before
  /// adding declarative markers and polylines.
  final Function()? onStyleLoaded;

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
  bool _isCameraMoving = false;
  String? _styleString;
  bool _isLoadingStyle = true;

  @override
  void initState() {
    super.initState();
    _loadStyle();
  }

  Future<void> _loadStyle() async {
    try {
      final url = _resolvedStyleUrl;
      print("🔥 [IntaleqMap] Resolving style: $url");

      if (url.startsWith('asset://')) {
        final assetPath = url.replaceFirst('asset://', '');
        _styleString = await rootBundle.loadString(assetPath);
        print("🔥 [IntaleqMap] Style loaded from asset string: ${assetPath.split('/').last}");
      } else {
        _styleString = url;
        print("🔥 [IntaleqMap] Using remote style URL: $url");
      }
    } catch (e) {
      print("❌ [IntaleqMap] Failed to load style: $e");
      _styleString = 'about:blank';
    } finally {
      if (mounted) {
        setState(() => _isLoadingStyle = false);
      }
    }
  }

  @override
  void didUpdateWidget(IntaleqMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mapType != widget.mapType ||
        oldWidget.styleUrl != widget.styleUrl) {
      _loadStyle();
    }

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
    // Default to local assets for performance and offline support
    return switch (widget.mapType) {
      IntaleqMapType.normal => 'asset://packages/intaleq_maps/assets/style_dark.json',
      IntaleqMapType.light => 'asset://packages/intaleq_maps/assets/style.json',
      IntaleqMapType.satellite => IntaleqStyles.satellite(widget.apiKey),
      IntaleqMapType.none => 'about:blank',
    };
  }

  Future<void> _onMapCreated(mgl.MapLibreMapController rawCtrl) async {
    // Wire up tap routing before handing the controller to the caller.
    rawCtrl.onSymbolTapped.add(_onSymbolTapped);
    rawCtrl.onLineTapped.add(_onLineTapped);

    final ctrl = await IntaleqMapController.create(
      raw: rawCtrl,
      apiKey: widget.apiKey,
    );
    _controller = ctrl;
    widget.onMapCreated?.call(ctrl);
  }

  void _onSymbolTapped(mgl.Symbol symbol) =>
      _controller?.onSymbolTapped(symbol);

  void _onLineTapped(mgl.Line line) => _controller?.onLineTapped(line);

  Future<void> _onStyleLoaded() async {
    final ctrl = _controller;
    if (ctrl == null) return;

    await ctrl.onStyleLoaded();
    final callbackResult = widget.onStyleLoaded?.call();
    if (callbackResult is Future) {
      await callbackResult;
    }

    // Re-render everything from the current declarative sets.
    // This ensures overlays persist across style changes (Dark/Light mode)
    // and during certain zoom/camera events that trigger style reloads.
    for (final m in widget.markers) await ctrl.addMarker(m);
    for (final p in widget.polylines) await ctrl.addPolyline(p);
    for (final c in widget.circles) await ctrl.addCircle(c);
    for (final g in widget.polygons) await ctrl.addPolygon(g);
    
    // Apply defaults AFTER markers have initialized the symbol layer
    await ctrl.applyMarkerVisibilityDefaults();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingStyle) {
      return const Center(child: CircularProgressIndicator());
    }

    return mgl.MaplibreMap(
      styleString: _styleString!,
      initialCameraPosition: widget.initialCameraPosition.toMapLibre(),
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoaded,
      onMapClick: widget.onTap != null
          ? (point, latlng) => widget.onTap!(latlng)
          : null,
      onMapLongClick: widget.onLongPress != null
          ? (point, latlng) => widget.onLongPress!(latlng)
          : null,
      onCameraIdle: () {
        _isCameraMoving = false;
        if (widget.autoCache) {
          final pos = _controller?.cameraPosition;
          if (pos != null) {
            IntaleqOfflineService.instance.downloadRegion(
              pos.target,
              styleUrl: _resolvedStyleUrl,
            );
          }
        }
        widget.onCameraIdle?.call();
      },
      onCameraTrackingChanged: null,
      myLocationEnabled: widget.myLocationEnabled,
      myLocationRenderMode: widget.myLocationEnabled
          ? mgl.MyLocationRenderMode.normal
          : mgl.MyLocationRenderMode.normal,
      myLocationTrackingMode: mgl.MyLocationTrackingMode.none,
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
      trackCameraPosition:
          widget.onCameraMove != null ||
              widget.onCameraMoveStarted != null ||
              widget.onCameraIdle != null,
      onCameraMove: (pos) {
        if (!_isCameraMoving && widget.onCameraMoveStarted != null) {
          _isCameraMoving = true;
          widget.onCameraMoveStarted!();
        }
        widget.onCameraMove?.call(CameraPosition.fromMapLibre(pos));
      },
      onCameraTrackingDismissed: null,
    );
  }
}
