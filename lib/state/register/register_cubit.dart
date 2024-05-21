import 'package:bloc/bloc.dart';
import 'package:quirknthreads/repositories/auth_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../models/email_status.dart';
import '../../models/form_status.dart';
import '../../models/password_status.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;
  RegisterCubit({
    required AuthRepository authRepository,
}) : _authRepository = authRepository,
        super(RegisterState());


  void emailChanged(String value) {
    try {
      emit(
        state.copyWith(
          email: value,
          emailStatus: EmailStatus.valid, //TODO: email validation
        ),
      );
    } on ArgumentError {
     // validate email

      emit(
        state.copyWith(
          emailStatus: EmailStatus.invalid,
        ),
      );

    } catch(err) {
      emit(
        state.copyWith(
          emailStatus: EmailStatus.invalid,
        ),
      );
    }
  }

  void passwordChanged(String value){
    final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    try {

      if (passwordRegExp.hasMatch(value)) {
        emit(
          state.copyWith(
            password: value,
            passwordStatus: PasswordStatus.valid,
          ),
        );
      } 
      else {
        // Password is invalid
        print("helloo password lousy");
        emit(
          state.copyWith(
            passwordStatus: PasswordStatus.invalid,
          ),
        );
      }

    } on ArgumentError {
      // validate email

      emit(
        state.copyWith(
          passwordStatus: PasswordStatus.invalid,
        ),
      );

    } catch(err) {
      emit(
        state.copyWith(
          passwordStatus: PasswordStatus.invalid,
        ),
      );
    }
  }

  Future<void> register() async {
    if (!(state.emailStatus == EmailStatus.valid) ||
    !(state.passwordStatus == PasswordStatus.valid)) {
      emit(state.copyWith(formStatus: FormStatus.invalid));
      emit(state.copyWith(formStatus: FormStatus.initial));
      return;
    }

    emit(state.copyWith(formStatus: FormStatus.submissionInProgress));

    try {
      await _authRepository.register(
        email: state.email!,
        password: state.password!,
      );
      emit (state.copyWith(formStatus: FormStatus.submissionSuccess));
    } catch (err) {
      emit (state.copyWith(formStatus: FormStatus.submissionFailure));
    }

  }

}
