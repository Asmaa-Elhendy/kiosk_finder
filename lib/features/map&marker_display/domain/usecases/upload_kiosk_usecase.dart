import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/kiosk_repository.dart';

class UploadKiosksUseCase {
  final KioskRepository repository;

  UploadKiosksUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String city, String locationsJsonPath)  {
    // The repository will handle reading from the JSON file and uploading the kiosks
    return repository.uploadKiosks(city, locationsJsonPath);
  }
}
