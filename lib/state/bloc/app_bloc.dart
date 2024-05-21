import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:quirknthreads/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  late StreamSubscription<firebase_auth.User?> _authUserSubscription;

  AppBloc({
    required AuthRepository authRepository,
    firebase_auth.User? user,
  }) : _authRepository = authRepository,
        super(
          user != null
              ? AppState.authenticated(user)
              : const AppState.unauthenticated(),
        ) {

    on<AppUserChanged>(_onAppUserChanged);
    on<AppLogoutRequested>(_onAppLogoutRequested);

    _authUserSubscription = _authRepository.authStateChanges.listen(
          (user) => _userChanged(user),
    );
  }

  void _userChanged(firebase_auth.User? user) {
    add(AppUserChanged(user: user));
  }

  _onAppUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit
    ) async {
    if (event.user == null) {
      emit(state.copyWith(status: AppStatus.unauthenticated, user: null));
    }else if (!(event.user?.emailVerified ?? false)){
            // if verified -> false here
            // if not verified -> true
      emit(state.copyWith(status: AppStatus.pendingEmail, user: null));
    } else {
      emit(state.copyWith(status: AppStatus.authenticated, user: event.user));
    }
  }

  _onAppLogoutRequested(
      AppLogoutRequested event,
      Emitter<AppState> emit,
      ) async {
    await _authRepository.logout();
  }

  @override
  Future<void> close() {
    _authUserSubscription.cancel();
    return super.close();
  }

}
