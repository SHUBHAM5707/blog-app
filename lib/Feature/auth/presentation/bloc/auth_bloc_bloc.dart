import 'package:blog/core/comman/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/comman/entities/user.dart';
import 'package:blog/Feature/auth/domain/usecases/current_user.dart';
import 'package:blog/Feature/auth/domain/usecases/user_login.dart';
import 'package:blog/Feature/auth/domain/usecases/user_signup.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentuser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentuser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(Noparams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSucess(r,emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
          email: event.email, password: event.password, name: event.name),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSucess(user,emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)), 
      (r) => _emitAuthSucess(r,emit), 
    );
  }

  void _emitAuthSucess(
    User user, 
    Emitter<AuthState> emit
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
