import '../../domain/entities/kiosk_entity.dart';

abstract class KioskState {}

class KioskInitialState extends KioskState {}

class KioskLoadingState extends KioskState {}

class KioskLoadedState extends KioskState {
  final List<Kiosk> kiosks;
  KioskLoadedState(this.kiosks);
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
