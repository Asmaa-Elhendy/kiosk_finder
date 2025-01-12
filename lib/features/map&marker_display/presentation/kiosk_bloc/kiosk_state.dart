import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/kiosk_entity.dart';

abstract class KioskState {}

class KioskInitialState extends KioskState {}

class KioskLoadingState extends KioskState {}

class KioskLoadedState extends KioskState {
  final List<Kiosk> kiosks;
  final Set<Marker> markers;

  KioskLoadedState({required this.kiosks, required this.markers});
}

class KioskEmptyState extends KioskState {
  final String message;
  KioskEmptyState(this.message);
}

class KioskUploadingState extends KioskState {}

class KioskUploadedState extends KioskState {
  final String message;
  KioskUploadedState(this.message);
}

class KioskErrorState extends KioskState {
  final String message;
  KioskErrorState(this.message);
}
