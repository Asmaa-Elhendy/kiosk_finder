// kiosk_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/kiosk_entity.dart';
import '../../domain/usecases/fetch_kiosks_usecase.dart';
import '../../domain/usecases/upload_kiosk_usecase.dart';
import 'kiosk_event.dart';
import 'kiosk_state.dart';

class KioskBloc extends Bloc<KioskEvent, KioskState> {
  final FetchKiosksUseCase fetchKiosksUseCase;
  final UploadKiosksUseCase uploadKiosksUseCase;

  KioskBloc({required this.fetchKiosksUseCase, required this.uploadKiosksUseCase})
      : super(KioskInitialState()) {
    on<KioskEvent>((event, emit) async {
      if (event is FetchKiosksEvent) {
        emit(KioskLoadingState());
        final failureOrResult = await fetchKiosksUseCase(event.city);
        emit(_mapFailureOrResultToState(failureOrResult));
      } else if (event is UploadKiosksEvent) {
        emit(KioskUploadingState());
        final result = await uploadKiosksUseCase(event.city, event.locationsJsonPath);
        emit(_mapUploadKiosksResultToState(result));
      }
    });
  }

  KioskState _mapFailureOrResultToState(Either<Failure, List<Kiosk>> either) {
    return either.fold(
          (failure) {
        return KioskErrorState('An error occurred');
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

  KioskState _mapUploadKiosksResultToState(void result) {
    return KioskUploadedState('Kiosks successfully uploaded');
  }
}
