// kiosk_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/strings/messages.dart';
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
        final failureOrUpload =
            await uploadKiosksUseCase(event.city, event.locationsJsonPath);
        emit(_mapUploadKiosksResultToState(failureOrUpload));
      }
    });
  }

  KioskState _mapFailureOrResultToState(Either<Failure, List<Kiosk>> either) {
    return either.fold(
      (failure) {
        return KioskErrorState(_mapFailureToMessage(failure));
      },
      (kiosks) {
        if (kiosks.isEmpty) {
          return KioskEmptyState('No kiosks found for this city.');
        } else {
          // Create markers for the kiosks
          Set<Marker> markers = kiosks.map((kiosk) {
            return Marker(
              markerId: MarkerId(kiosk.placeId.toString()),
              position: LatLng(kiosk.lat, kiosk.lng),
              infoWindow: InfoWindow(title: kiosk.name, snippet: kiosk.city),
            );
          }).toSet();

          return KioskLoadedState(kiosks: kiosks, markers: markers);
        }
      },
    );
  }

  KioskState _mapUploadKiosksResultToState(Either<Failure, Unit> either) {
    return either.fold(
      (failure) {
        return KioskErrorState(_mapFailureToMessage(failure));
      },
      (_) {
        return KioskUploadedState(UPLOAD_SUCCESSFULLY);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case FirestoreReadFailure:
        return FIRESTORE_READ_FAILURE_MESSAGE;
      case FileReadFailure:
        return FILE_READ_FAILURE_MESSAGE;
      case UnexpectedFailure:
        return UNEXPECTED_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case FirestoreWriteFailure:
        return FIRESTORE_WRITE_FAILURE_MESSAGE;
      default:
        return DEFAULT_FAILURE_MESSAGE;
    }
  }
}
