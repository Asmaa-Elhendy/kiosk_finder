
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/kiosk_entity.dart';

abstract class KioskRepository {
  Future<Either<Failure, Unit>> uploadKiosks(String city, String locationsJsonPath);
  Future<Either<Failure,List<Kiosk>>>  fetchKiosks(String city);
}
