import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kiosk_finder/core/error/exceptions.dart';
import 'package:kiosk_finder/core/util/snack_bar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/kiosk_entity.dart';
import '../kiosk_bloc/kiosk_bloc.dart';
import '../kiosk_bloc/kiosk_event.dart';
import '../kiosk_bloc/kiosk_state.dart';

class KioskDataPage extends StatefulWidget {
  final String city;

  KioskDataPage({required this.city});

  @override
  _KioskDataPageState createState() => _KioskDataPageState();
}

class _KioskDataPageState extends State<KioskDataPage> {
  late GoogleMapController _mapController;
  late LatLng _currentPosition;
  late Set<Marker> _markers = {};
  late Map<String, List<Kiosk>> _clusters = {};
  bool _isClusterView = true;

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(37.7749, -122.4194); // Default position
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kiosks for ${widget.city}')),
      body: BlocConsumer<KioskBloc, KioskState>(
        listener: (context, state) {
          if (state is KioskUploadedState) {
            SnackBarMessage().showSuccessSnackBar(
              message: state.message,
              context: context,
            );
          } else if (state is KioskErrorState) {
            SnackBarMessage().showErrorSnackBar(
              message: state.message,
              context: context,
            );
          }
        },
        builder: (context, state) {
          if (state is KioskLoadingState) {
            return LoadingWidget();
          } else if (state is KioskLoadedState) {
            _prepareClusters(state.kiosks);
            return _buildMapView(state.kiosks, _currentPosition);
          } else if (state is KioskEmptyState) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Unexpected error. Please try again.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<KioskBloc>(context).add(
            UploadKiosksEvent(
              widget.city,
              widget.city == 'city2'
                  ? 'assets/cities/locationsB.json'
                  : 'assets/cities/locationsA.json',
            ),
          );
        },
        child: Icon(Icons.upload),
        tooltip: 'Upload Kiosks',
      ),
    );
  }

  // Prepare clusters by grouping kiosks based on district names
  void _prepareClusters(List<Kiosk> kiosks) {
    _clusters = {};
    for (var kiosk in kiosks) {
      String district = _normalizeDistrictName(kiosk.districtName);
      _clusters.putIfAbsent(district, () => []).add(kiosk);
    }
  }

  // Build the map view with cluster markers or individual kiosks
  Widget _buildMapView(List<Kiosk> kiosks, LatLng _currentPosition) {
    Set<Marker> clusterMarkers = _buildClusterMarkers(kiosks);
    Set<Marker> individualMarkers = _buildKioskMarkers(kiosks);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: clusterMarkers.isEmpty
            ? _currentPosition
            : clusterMarkers.first.position,
        zoom: 12,
      ),
      markers: _isClusterView ? clusterMarkers : individualMarkers,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      onCameraMove: (CameraPosition position) {
        _toggleMarkerView(position.zoom);
      },
    );
  }

  // Build the cluster markers (district level)
  Set<Marker> _buildClusterMarkers(List<Kiosk> kiosks) {
    return _clusters.entries.map((entry) {
      LatLng clusterPosition = _calculateCentroid(entry.value);
      return Marker(
        markerId: MarkerId('${entry.key}_${entry.value.hashCode}'),
        position: clusterPosition,
        infoWindow: InfoWindow(
          title: entry.key,
          snippet: '${entry.value.length} kiosks',
        ),
        onTap: () {
          _showKioskMarkers(entry.value);
        },
      );
    }).toSet();
  }

  // Build individual kiosk markers
  Set<Marker> _buildKioskMarkers(List<Kiosk> kiosks) {
    return kiosks.map((kiosk) {
      return Marker(
        markerId: MarkerId(kiosk.placeId.toString()),
        position: LatLng(kiosk.lat, kiosk.lng),
        infoWindow: InfoWindow(
          title: kiosk.name,
          snippet: '${kiosk.city}, ${kiosk.districtName}',
        ),
      );
    }).toSet();
  }

  // Normalize district names to avoid duplicates
  String _normalizeDistrictName(String districtName) {
    return districtName.trim(); // Remove leading/trailing spaces
  }

  // Toggle between cluster view and individual markers based on zoom level
  void _toggleMarkerView(double zoomLevel) {
    setState(() {
      if (zoomLevel >= 15) {
        _isClusterView = false; // Show individual kiosk markers when zoomed in
      } else {
        _isClusterView = true; // Show cluster markers when zoomed out
      }
    });
  }

  // Show individual kiosks for a district when a cluster is tapped
  void _showKioskMarkers(List<Kiosk> kiosks) {
    Set<Marker> districtMarkers = _buildKioskMarkers(kiosks);
    setState(() {
      _markers = districtMarkers;
    });

    // Adjust the camera to fit the selected kiosk markers
    if (kiosks.isNotEmpty) {
      LatLngBounds bounds = _calculateBounds(kiosks);
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  // Calculate centroid of kiosks in a district
  LatLng _calculateCentroid(List<Kiosk> kiosks) {
    double latSum = 0;
    double lngSum = 0;

    for (var kiosk in kiosks) {
      latSum += kiosk.lat;
      lngSum += kiosk.lng;
    }

    return LatLng(latSum / kiosks.length, lngSum / kiosks.length);
  }

  // Calculate bounds for a list of kiosks
  LatLngBounds _calculateBounds(List<Kiosk> kiosks) {
    double north = kiosks.first.lat;
    double south = kiosks.first.lat;
    double east = kiosks.first.lng;
    double west = kiosks.first.lng;

    for (var kiosk in kiosks) {
      if (kiosk.lat > north) north = kiosk.lat;
      if (kiosk.lat < south) south = kiosk.lat;
      if (kiosk.lng > east) east = kiosk.lng;
      if (kiosk.lng < west) west = kiosk.lng;
    }

    return LatLngBounds(
      northeast: LatLng(north, east),
      southwest: LatLng(south, west),
    );
  }
}
