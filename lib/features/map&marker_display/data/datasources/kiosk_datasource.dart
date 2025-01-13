import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart'; // Custom exceptions
import '../models/kiosk_model.dart';

abstract class KioskRemoteDataSource {
  Future<void> uploadKiosks(String city, List<KioskModel> kiosks);
  Stream<List<KioskModel>> fetchKiosks(String city);
}

class KioskRemoteDataSourceImpl extends KioskRemoteDataSource {
  final FirebaseFirestore firestore;
  final SharedPreferences sharedPreferences;
  KioskRemoteDataSourceImpl(
      {required this.firestore, required this.sharedPreferences});

  @override
  Future<void> uploadKiosks(String city, List<KioskModel> kiosks) async {
    final batch = firestore
        .batch(); //Creates a Firestore batch object, allow to perform multiple write operations as a single atomic transaction.
    if (sharedPreferences.containsKey(city)) {
      throw AlreadyUploadJsonFileException();
    } else {
      try {
        for (final kiosk in kiosks) {
          final docRef = firestore.collection(city).doc(kiosk.placeId);
          batch.set(docRef, kiosk.toJson());
        }
        await batch
            .commit(); //write operations in the batch as a single transaction.
        sharedPreferences.setString(city, city);
      } catch (e) {
        throw FirestoreWriteException();
      }
    }
  }

  @override
  Stream<List<KioskModel>> fetchKiosks(String city) {
    try {
      return firestore.collection(city).snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => KioskModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw FirestoreReadException();
    }
  }
}
