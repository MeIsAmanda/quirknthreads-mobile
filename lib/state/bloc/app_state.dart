part of 'app_bloc.dart';

enum AppStatus {unknown, authenticated, unauthenticated}

class AppState extends Equatable{
  final AppStatus status;
  final firebase_auth.User? user;


  const AppState({required this.status, this.user});

  const AppState.authenticated(firebase_auth.User user)
    : this(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated()
    : this (
        status: AppStatus.unauthenticated,
        user: null,
    );

  AppState copyWith({
    AppStatus? status,
    firebase_auth.User? user,
}) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];

}

