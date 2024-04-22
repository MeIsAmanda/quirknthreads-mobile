part of 'app_bloc.dart';

class AppEvent extends Equatable{
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppUserChanged extends AppEvent {
  final firebase_auth.User? user;
  const AppUserChanged({required this.user});

  @override
  List<Object?> get props => [user];
}

class AppLogoutRequested extends AppEvent {

}
