import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';  // Import Geolocator
import 'package:permission_handler/permission_handler.dart';  // Import permission_handler for runtime permissions

import '../../../../core/widgets/loading_widget.dart';
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
  late Set<Marker> _markers = Set(); // Store markers
  bool _isLocationFetched = false;  // Flag to ensure map updates only after location is fetched

  @override
  void initState() {
    super.initState();
    // Set initial position to San Francisco by default
    _currentPosition = LatLng(37.7749, -122.4194); // Default to San Francisco

    // Check permissions and attempt to get location if required
    _checkPermissionsAndGetLocation();
  }

  // Check and request location permissions, then get the current location
  Future<void> _checkPermissionsAndGetLocation() async {
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      // Permissions are granted, now get the current location
      _getCurrentLocation();
    } else {
      // Permissions not granted, keep default position (San Francisco)
      print("Location permission denied.");
      setState(() {
        _currentPosition = LatLng(37.7749, -122.4194); // San Francisco
      });
    }
  }

  // Fetch current location using Geolocator
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        // Update the map to the user's current location
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLocationFetched = true; // Mark the location as fetched
      });
      // If map controller is initialized, move the camera to the current location
      if (_mapController != null) {
        _mapController.animateCamera(
          CameraUpdate.newLatLng(_currentPosition), // Update camera position
        );
      }
    } catch (e) {
      // If location access fails, keep the default location (San Francisco)
      print("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kiosks for ${widget.city}')),
      body: BlocConsumer<KioskBloc, KioskState>(
        listener: (context, state) {
          if (state is KioskUploadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is KioskErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is KioskLoadingState) {
            return LoadingWidget();
          } else if (state is KioskLoadedState) {
            // Fetch the first kiosk location from the state and use it for the camera position
            if (state.kiosks.isNotEmpty) {
              LatLng firstKioskPosition = LatLng(
                  state.kiosks[0].lat, state.kiosks[0].lng);
              return _buildMapView(state.markers, firstKioskPosition);
            } else {
              return Center(child: Text('No kiosks available.'));
            }
          } else if (state is KioskEmptyState) {
            return Center(child: Text(state.message));
          } else if (state is KioskUploadingState) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text('Unexpected state. Please try again.'));
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

  // Build the map view using the markers from the state and center it on the first kiosk location
  Widget _buildMapView(Set<Marker> markers, LatLng firstKioskPosition) {
    _markers = markers;
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: firstKioskPosition, // Use the first kiosk position from the state
        zoom: 12,
      ),
      markers: _markers,
      myLocationEnabled: true, // Enable the location button on the map
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
    );
  }
}
