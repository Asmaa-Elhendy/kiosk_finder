class OfflineException implements Exception {}

//class FirebaseAuthException implements Exception {}

class ServerException implements Exception {}

class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class WeakPasswordException implements Exception {}

class InvalidEmailException implements Exception {}

class FirestoreWriteException implements Exception {

  FirestoreWriteException();
}

class FirestoreReadException implements Exception {

  FirestoreReadException();
}

class FileReadException implements Exception {

  FileReadException();
}
class AlreadyUploadJsonFileException implements Exception{
  AlreadyUploadJsonFileException();
}