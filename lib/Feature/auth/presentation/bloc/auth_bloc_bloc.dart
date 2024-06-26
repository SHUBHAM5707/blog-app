import 'package:blog/Feature/auth/domain/usecases/user_signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  AuthBloc({
    required UserSignUp userSignUp,
  })  : _userSignUp = userSignUp,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      final res = await _userSignUp(UserSignUpParams(
          email: event.email, 
          password: event.password, 
          name: event.name
        ),
      );

      res.fold(
        (l) => emit(AuthFailure(l.message)), 
        (r) => emit (AuthSuccess(r)));
    });
  }
}
