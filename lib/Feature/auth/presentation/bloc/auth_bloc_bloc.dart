import 'package:blog/Feature/auth/domain/entities/user.dart';
import 'package:blog/Feature/auth/domain/usecases/user_login.dart';
import 'package:blog/Feature/auth/domain/usecases/user_signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
  }
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
          email: event.email, password: event.password, name: event.name),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) {
        emit(AuthSuccess(user));
      },
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
        UserLoginParams(
          email: event.email, 
          password: event.password
        ),
      );

      res.fold((l)=> emit(AuthFailure(l.message)),(r) => emit(AuthSuccess(r)));
  }
}
