import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/kiosk_entity.dart';
import '../../domain/usecases/fetch_kiosks_usecase.dart';
import '../../domain/usecases/upload_kiosk_usecase.dart';
import 'kiosk_event.dart';
import 'kiosk_state.dart';

class KioskBloc extends Bloc<KioskEvent, KioskState> {
  final FetchKiosksUseCase fetchKiosksUseCase;
  final UploadKiosksUseCase uploadKiosksUseCase;

  KioskBloc(
      {required this.fetchKiosksUseCase, required this.uploadKiosksUseCase})
      : super(KioskInitialState()) {
    on<KioskEvent>((event, emit) async {
      if (event is FetchKiosksEvent) {
        emit(KioskLoadingState());
        final failureOrResult = await fetchKiosksUseCase(event.city);
        emit(_mapFailureOrResultToState(failureOrResult));
      } else if (event is UploadKiosksEvent) {
        emit(KioskUploadingState());
        final result =
            await uploadKiosksUseCase(event.city, event.locationsJsonPath);
        emit(_mapUploadKiosksResultToState(result));
      }
    });
  }

  KioskState _mapFailureOrResultToState(Either<Failure, List<Kiosk>> either) {
    return either.fold(
      (failure) {
        // Map failure to specific error states
        if (failure is FirestoreReadFailure) {
          return KioskErrorState('Failed to fetch kiosks: ${failure.message}');
        } else if (failure is FirestoreWriteFailure) {
          return KioskErrorState('Failed to upload kiosks: ${failure.message}');
        } else if (failure is FileReadFailure) {
          return KioskErrorState('Failed to read the file: ${failure.message}');
        } else {
          return KioskErrorState('An unexpected error occurred');
        }
      },
      (kiosks) {
        if (kiosks.isEmpty) {
          return KioskEmptyState('No kiosks found for this city.');
        } else {
          return KioskLoadedState(kiosks);
        }
      },
    );
  }

  // Helper method for uploading kiosks
  KioskState _mapUploadKiosksResultToState(Either<Failure, Unit> result) {
    return result.fold(
      (failure) {
        // Handle upload failure cases
        if (failure is FirestoreWriteFailure) {
          return KioskErrorState('Failed to upload kiosks: ${failure.message}');
        } else {
          return KioskErrorState('An error occurred during upload');
        }
      },
      (_) {
        // Handle success
        return KioskUploadedState('Kiosks successfully uploaded');
      },
    );
  }
}
