import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:kiosk_finder/core/strings/messages.dart';
import 'package:kiosk_finder/features/authentication/domain/entities/user.dart';
import 'package:kiosk_finder/features/authentication/domain/usecases/signin_usecase.dart';
import 'package:kiosk_finder/features/authentication/domain/usecases/signup_usecase.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  SignUpUseCase signUpUseCase;
  SignInUseCase signInUseCase;

  AuthBloc({required this.signUpUseCase, required this.signInUseCase})
      : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is SignUpEvent) {
        emit(LoadingAuthState());
        final eitherFailureOrMessage = await signUpUseCase(event.user);
        emit(_EitherDoneMessageOrErrorState(
            eitherFailureOrMessage, SIGN_UP_MESSAGE));
      } else if (event is SignInEvent) {
        emit(LoadingAuthState());
        final eitherFailureOrMessage = await signInUseCase(event.user);
        emit(_EitherDoneMessageOrErrorState(
            eitherFailureOrMessage, SIGN_IN_MESSAGE));
      }
    });
  }
  AuthState _EitherDoneMessageOrErrorState(
      Either<Failure, UserEntity> eitherFailureOrMessage, String message) {
    return eitherFailureOrMessage.fold((failure) {
      return ErrorAuthState(message: _FailureToMessage(failure));
    }, (_) {
      return MessageAuthState(message: message);
    });
  }

  String _FailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case FirebaseAuthFailure:
        return FIREBASE_AUTH_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case UserNotFoundFailure:
        return USER_NOT_FOUND_MESSAGE;
      case WrongPasswordFailure:
        return WRONG_PASSWORD_MESSAGE;
      case EmailAlreadyInUseFailure:
        return EMAIL_ALREADY_IN_USE_MESSAGE;
      case WeakPasswordFailure:
        return WEAK_PASSWORD_MESSAGE;
      case InvalidEmailFailure:
        return INVALID_EMAIL;
      default:
        return "UnexpectedError , please try again later.";
    }
  }
}
