class OfflineException implements Exception {}

//class FirebaseAuthException implements Exception {}

class ServerException implements Exception {}

class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class WeakPasswordException implements Exception {}

class InvalidEmailException implements Exception {}

class FirestoreWriteException implements Exception {
  final String message;
  FirestoreWriteException(this.message);
}

class FirestoreReadException implements Exception {
  final String message;
  FirestoreReadException(this.message);
}

class FileReadException implements Exception {
  final String message;
  FileReadException(this.message);
}
