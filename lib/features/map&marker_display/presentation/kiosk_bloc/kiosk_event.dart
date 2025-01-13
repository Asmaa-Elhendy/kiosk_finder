
import 'package:equatable/equatable.dart';

import '../../domain/entities/kiosk_entity.dart';

abstract class KioskEvent extends Equatable {}

class FetchKiosksEvent extends KioskEvent {
  final String city;
  FetchKiosksEvent(this.city);
  @override
  List<Object?> get props => [city];
}

class UploadKiosksEvent extends KioskEvent {
  final String city;
  final String locationsJsonPath;
  UploadKiosksEvent(this.city, this.locationsJsonPath);
  @override
  List<Object?> get props => [city, locationsJsonPath];
}
