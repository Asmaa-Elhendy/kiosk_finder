// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart'; // Import Geolocator
// import 'package:kiosk_finder/core/util/snack_bar_message.dart';
// import 'package:permission_handler/permission_handler.dart'; // Import permission_handler for runtime permissions
//
// import '../../../../core/widgets/loading_widget.dart';
// import '../../domain/entities/kiosk_entity.dart';
// import '../kiosk_bloc/kiosk_bloc.dart';
// import '../kiosk_bloc/kiosk_event.dart';
// import '../kiosk_bloc/kiosk_state.dart';
//
// class KioskDataPage extends StatefulWidget {
//   final String city;
//
//   KioskDataPage({required this.city});
//
//   @override
//   _KioskDataPageState createState() => _KioskDataPageState();
// }
//
// class _KioskDataPageState extends State<KioskDataPage> {
//   late GoogleMapController _mapController;
//   late LatLng _currentPosition;
//   late Set<Marker> _markers = Set(); // Store markers
//   bool _isLocationFetched =
//   false; // Flag to ensure map updates only after location is fetched
//
//   @override
//   void initState() {
//     super.initState();
//     // Set initial position to San Francisco by default
//     _currentPosition = LatLng(37.7749, -122.4194); // Default to San Francisco
//
//     // Check permissions and attempt to get location if required
//     // _checkPermissionsAndGetLocation();
//   }
//
//   // Check and request location permissions, then get the current location
//   // Future<void> _checkPermissionsAndGetLocation() async {
//   //   PermissionStatus permissionStatus = await Permission.location.request();
//   //
//   //   if (permissionStatus.isGranted) {
//   //     // Permissions are granted, now get the current location
//   //     _getCurrentLocation();
//   //   } else {
//   //     // Permissions not granted, keep default position (San Francisco)
//   //     print("Location permission denied.");
//   //     setState(() {
//   //       _currentPosition = LatLng(37.7749, -122.4194); // San Francisco
//   //     });
//   //   }
//   // }
//
//   // Fetch current location using Geolocator
//   // Future<void> _getCurrentLocation() async {
//   //   try {
//   //     Position position = await Geolocator.getCurrentPosition();
//   //     setState(() {
//   //       // Update the map to the user's current location
//   //       _currentPosition = LatLng(position.latitude, position.longitude);
//   //       _isLocationFetched = true; // Mark the location as fetched
//   //     });
//   //     // If map controller is initialized, move the camera to the current location
//   //     if (_mapController != null) {
//   //       _mapController.animateCamera(
//   //         CameraUpdate.newLatLng(_currentPosition), // Update camera position
//   //       );
//   //     }
//   //   } catch (e) {
//   //     // If location access fails, keep the default location (San Francisco)
//   //     print("Error fetching location: $e");
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Kiosks for ${widget.city}')),
//       body: BlocConsumer<KioskBloc, KioskState>(
//         listener: (context, state) {
//           if (state is KioskUploadedState) {
//             SnackBarMessage()
//                 .showSuccessSnackBar(message: state.message, context: context);
//           } else if (state is KioskErrorState) {
//             SnackBarMessage()
//                 .showErrorSnackBar(message: state.message, context: context);
//           }
//         },
//         builder: (context, state) {
//           if (state is KioskLoadingState) {
//             return LoadingWidget();
//           } else if (state is KioskLoadedState) {
//             // Fetch the first kiosk location from the state and use it for the camera position
//
//             LatLng firstKioskPosition =
//             LatLng(state.kiosks[0].lat, state.kiosks[0].lng);
//             return _buildMapView(state.kiosks, firstKioskPosition);
//           }else if (state is KioskEmptyState){
//             return Center(child: Text(state.message));
//           }
//           // else if (state is KioskEmptyState) {
//           //   return Center(child: Text(state.message));
//           // } else if (state is KioskUploadingState) {
//           //   return Center(child: CircularProgressIndicator());
//           // }
//           else {
//             return Center(child: Text('Unexpected error. Please try again.'));
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           BlocProvider.of<KioskBloc>(context).add(
//             UploadKiosksEvent(
//               widget.city,
//               widget.city == 'city2'
//                   ? 'assets/cities/locationsB.json'
//                   : 'assets/cities/locationsA.json',
//             ),
//           );
//         },
//         child: Icon(Icons.upload),
//         tooltip: 'Upload Kiosks',
//       ),
//     );
//   }
//
//   // Build the map view using the markers from the state and center it on the first kiosk location
//   // Widget _buildMapView(List<Kiosk> kiosks, LatLng firstKioskPosition) {
//   //   _markers = kiosks.map((kiosk) {
//   //     return Marker(
//   //       markerId: MarkerId(kiosk.placeId.toString()),
//   //       position: LatLng(kiosk.lat, kiosk.lng),
//   //       infoWindow: InfoWindow(
//   //         title: kiosk.name,
//   //         snippet: kiosk.city+", "+kiosk.lat.toString()+kiosk.lng.toString(),
//   //       ),
//   //       onTap: () {
//   //
//   //       },
//   //     );
//   //   }).toSet();
//   //   return GoogleMap(
//   //     initialCameraPosition: CameraPosition(
//   //       target:
//   //       firstKioskPosition, // Use the first kiosk position from the state
//   //       zoom: 12,
//   //     ),
//   //     markers: _markers,
//   //     myLocationEnabled: true, // Enable the location button on the map
//   //     onMapCreated: (GoogleMapController controller) {
//   //       _mapController = controller;
//   //     },
//   //   );
//   // }
//   Widget _buildMapView(List<Kiosk> kiosks, LatLng firstKioskPosition) {
//     // Group kiosks by normalized district names
//     Map<String, List<Kiosk>> clusters = {};
//     for (var kiosk in kiosks) {
//       String normalizedDistrict = _normalizeDistrictName(kiosk.districtName);
//       clusters.putIfAbsent(normalizedDistrict, () => []).add(kiosk);
//     }
//
//     // Create cluster markers
//     Set<Marker> _clusterMarkers = clusters.entries.map((entry) {
//       // Calculate the centroid of kiosks in this district
//       LatLng clusterPosition = _calculateCentroid(entry.value);
//       return  Marker(
//         markerId: MarkerId('${entry.key}_${entry.value.hashCode}'),
//         position: clusterPosition,
//         infoWindow: InfoWindow(
//           title: entry.key,
//           snippet: '${entry.value.length} kiosks',
//         ),
//         onTap: () {
//           _showKioskMarkers(entry.value);
//         },
//       );
//
//     }).toSet();
//
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: firstKioskPosition, // Use the first kiosk position
//         zoom: 12,
//       ),
//       markers: _clusterMarkers,
//       myLocationEnabled: true,
//       onMapCreated: (GoogleMapController controller) {
//         _mapController = controller;
//       },
//       onCameraMove: (CameraPosition position) {
//       if (position.zoom >= 15) {
//         // Show individual kiosks when zoomed in
//        // setState(() {
//           _markers = kiosks.map((kiosk) {
//             return Marker(
//               markerId: MarkerId(kiosk.placeId.toString()),
//               position: LatLng(kiosk.lat, kiosk.lng),
//               infoWindow: InfoWindow(
//                 title: kiosk.name,
//                 snippet: '${kiosk.city}, ${kiosk.districtName}',
//               ),
//             );
//           }).toSet();
//        // });
//       } else {
//         // Show clusters when zoomed out
//      //   setState(() {
//           _markers = _clusterMarkers;
//      //   });
//       }
//     }
//     ,
//     );
//   }
//
// // Normalize district names to avoid duplicates
//   String _normalizeDistrictName(String districtName) {
//     return districtName.trim(); // Remove leading/trailing spaces
//   }
//
// // Show individual kiosks in a district
//   void _showKioskMarkers(List<Kiosk> kiosks) {
//     // Create individual markers for kiosks in the selected cluster
//     Set<Marker> districtMarkers = kiosks.map((kiosk) {
//       return Marker(
//         markerId: MarkerId(kiosk.placeId.toString()),
//         position: LatLng(kiosk.lat, kiosk.lng),
//         infoWindow: InfoWindow(
//           title: kiosk.name,
//           snippet: '${kiosk.city}, ${kiosk.districtName}',
//         ),
//       );
//     }).toSet();
//
//   //  setState(() { //remove setstate
//       // Temporarily replace cluster markers with individual kiosk markers
//       _markers = districtMarkers;
//    // });
//
//     // Move the camera to focus on the kiosks in this cluster
//     if (kiosks.isNotEmpty) {
//       LatLngBounds bounds = _calculateBounds(kiosks);
//       _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
//     }
//   }
//
//
//
// // Calculate centroid of a list of kiosks
//   LatLng _calculateCentroid(List<Kiosk> kiosks) {
//     double latSum = 0;
//     double lngSum = 0;
//
//     for (var kiosk in kiosks) {
//       latSum += kiosk.lat;
//       lngSum += kiosk.lng;
//     }
//
//     return LatLng(latSum / kiosks.length, lngSum / kiosks.length);
//   }
//
// // Show individual kiosks in a district
//
//
// // Calculate bounds for a list of kiosks
//   LatLngBounds _calculateBounds(List<Kiosk> kiosks) {
//     double north = kiosks.first.lat;
//     double south = kiosks.first.lat;
//     double east = kiosks.first.lng;
//     double west = kiosks.first.lng;
//
//     for (var kiosk in kiosks) {
//       if (kiosk.lat > north) north = kiosk.lat;
//       if (kiosk.lat < south) south = kiosk.lat;
//       if (kiosk.lng > east) east = kiosk.lng;
//       if (kiosk.lng < west) west = kiosk.lng;
//     }
//
//     return LatLngBounds(
//       northeast: LatLng(north, east),
//       southwest: LatLng(south, west),
//     );
//   }
//
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
          } 
          else {
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

  Widget _buildMapView(List<Kiosk> kiosks, LatLng defaultPosition) {
    // Group kiosks by normalized district names
    Map<String, List<Kiosk>> clusters = {};
    for (var kiosk in kiosks) {
      String normalizedDistrict = _normalizeDistrictName(kiosk.districtName);
      clusters.putIfAbsent(normalizedDistrict, () => []).add(kiosk);
    }

    // Create cluster markers
    Set<Marker> _clusterMarkers = clusters.entries.map((entry) {
      // Calculate the centroid of kiosks in this district
      LatLng clusterPosition = _calculateCentroid(entry.value);
      return Marker(
        markerId: MarkerId('${entry.key}_${entry.value.hashCode}'),
        position: clusterPosition,
        infoWindow: InfoWindow(
          title: entry.key,
          snippet: '${entry.value.length} kiosks',
        ),
        onTap: () {

       //   _showKioskMarkers(entry.value);update here
        },
      );
    }).toSet();

    // Determine the initial position
    LatLng initialPosition = defaultPosition;
    if (clusters.isNotEmpty) {
      // Use the position of the first cluster as the initial position
      initialPosition = _calculateCentroid(clusters.values.first);
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition, // Use the determined initial position
        zoom: 12,
      ),
      markers: _clusterMarkers,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      onCameraMove: (CameraPosition position) {
        if (position.zoom >= 15) {
          // Show individual kiosks when zoomed in
          _markers = kiosks.map((kiosk) {
            return Marker(
              markerId: MarkerId(kiosk.placeId.toString()),
              position: LatLng(kiosk.lat, kiosk.lng),
              infoWindow: InfoWindow(
                title: kiosk.name,
                snippet: '${kiosk.city}, ${kiosk.districtName}',
              ),
            );
          }).toSet();
        } else {
          // Show clusters when zoomed out
          _markers = _clusterMarkers;
        }
      },
    );
  }


  void _prepareClusters(List<Kiosk> kiosks) {
    _clusters.clear();
    for (var kiosk in kiosks) {
      String normalizedDistrict = _normalizeDistrictName(kiosk.districtName);
      _clusters.putIfAbsent(normalizedDistrict, () => []).add(kiosk);
    }
  }

  // void _updateClusterMarkers() {
  //   setState(() {
  //     if (_isClusterView) {
  //       // Show cluster markers
  //       _markers = _clusters.entries.map((entry) {
  //         LatLng clusterPosition = _calculateCentroid(entry.value);
  //         return Marker(
  //           markerId: MarkerId('${entry.key}_${entry.value.hashCode}'),
  //           position: clusterPosition,
  //           infoWindow: InfoWindow(
  //             title: entry.key,
  //             snippet: '${entry.value.length} kiosks',
  //           ),
  //           onTap: () {
  //             _showKioskMarkers(entry.value);
  //           },
  //         );
  //       }).toSet();
  //     } else {
  //       // Show individual kiosk markers
  //       _markers = _clusters.values.expand((kiosks) {
  //         return kiosks.map((kiosk) {
  //           return Marker(
  //             markerId: MarkerId(kiosk.placeId.toString()),
  //             position: LatLng(kiosk.lat, kiosk.lng),
  //             infoWindow: InfoWindow(
  //               title: kiosk.name,
  //               snippet: '${kiosk.city}, ${kiosk.districtName}',
  //             ),
  //           );
  //         });
  //       }).toSet();
  //     }
  //   });
  // }

  // void _showKioskMarkers(List<Kiosk> kiosks) {
  //   setState(() {
  //     _markers = kiosks.map((kiosk) {
  //       return Marker(
  //         markerId: MarkerId(kiosk.placeId.toString()),
  //         position: LatLng(kiosk.lat, kiosk.lng),
  //         infoWindow: InfoWindow(
  //           title: kiosk.name,
  //           snippet: '${kiosk.city}, ${kiosk.districtName}',
  //         ),
  //       );
  //     }).toSet();
  //   });
  //
  //   if (kiosks.isNotEmpty) {
  //     LatLngBounds bounds = _calculateBounds(kiosks);
  //     _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  //   }
  // }

  LatLng _calculateCentroid(List<Kiosk> kiosks) {
    double latSum = kiosks.fold(0, (sum, kiosk) => sum + kiosk.lat);
    double lngSum = kiosks.fold(0, (sum, kiosk) => sum + kiosk.lng);
    return LatLng(latSum / kiosks.length, lngSum / kiosks.length);
  }

  LatLngBounds _calculateBounds(List<Kiosk> kiosks) {
    double north = kiosks.first.lat, south = kiosks.first.lat;
    double east = kiosks.first.lng, west = kiosks.first.lng;

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

  String _normalizeDistrictName(String districtName) {
    return districtName.trim();
  }
}
