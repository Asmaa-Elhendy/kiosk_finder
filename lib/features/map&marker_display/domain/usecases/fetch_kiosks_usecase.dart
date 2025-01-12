import 'package:dartz/dartz.dart';

import 'package:kiosk_finder/core/error/failures.dart';

import '../entities/kiosk_entity.dart';
import '../repositories/kiosk_repository.dart';

class FetchKiosksUseCase {
  final KioskRepository repository;

  FetchKiosksUseCase(this.repository);

  Future<Either<Failure, List<Kiosk>>> call(String city) {
    return repository.fetchKiosks(city);
  }
}
