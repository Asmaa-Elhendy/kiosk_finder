import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/kiosk_entity.dart';
import '../../domain/repositories/kiosk_repository.dart';
import '../datasources/kiosk_datasource.dart';
import '../models/kiosk_model.dart';

class KioskRepositoryImpl implements KioskRepository {
  final KioskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  KioskRepositoryImpl(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, Unit>> uploadKiosks(
      String city, String locationsJsonPath) async {
    if (await networkInfo.isConnected) {
      try {
        final kiosks = await loadKiosksFromJson(locationsJsonPath);
        await remoteDataSource.uploadKiosks(city, kiosks);
        return Right(unit);
      } on FileReadException {
        return Left(FileReadFailure());
      } on FirestoreWriteException {
        return Left(FirestoreWriteFailure());
      } catch (e) {
        return Left(UnexpectedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<List<KioskModel>> loadKiosksFromJson(String locationsJsonPath) async {
    try {
      final jsonString = await _loadJson(locationsJsonPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> kiosksData = jsonData.values.toList();
      return kiosksData
          .map((kioskData) => KioskModel.fromJson(kioskData))
          .toList();
    } catch (e) {
      throw FileReadException();
    }
  }

  Future<String> _loadJson(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      throw FileReadException();
    }
  }

  @override
  Future<Either<Failure, List<Kiosk>>> fetchKiosks(String city) async {
    if (await networkInfo.isConnected) {
      try {
        final kioskModelsStream = remoteDataSource.fetchKiosks(city);
        final kioskModels = await kioskModelsStream.first;
        return Right(kioskModels.map((model) => model.toEntity()).toList());
      } on FirestoreReadException catch (e) {
        return Left(FirestoreReadFailure());
      } catch (e) {
        return Left(UnexpectedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
