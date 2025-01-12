import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart'; // Custom exceptions
import '../models/kiosk_model.dart';

abstract class KioskRemoteDataSource {
  Future<void> uploadKiosks(String city, List<KioskModel> kiosks);
  Stream<List<KioskModel>> fetchKiosks(String city);
}

class KioskRemoteDataSourceImpl extends KioskRemoteDataSource {
  final FirebaseFirestore firestore;

  KioskRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> uploadKiosks(String city, List<KioskModel> kiosks) async {
    final batch = firestore.batch();
    try {
      for (final kiosk in kiosks) {
        final docRef = firestore.collection(city).doc(kiosk.placeId);
        batch.set(docRef, kiosk.toJson());
      }
      await batch.commit();
    } catch (e) {
      throw FirestoreWriteException("Failed to upload kiosks: $e");
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
      throw FirestoreReadException("Failed to fetch kiosks: $e");
    }
  }
}
