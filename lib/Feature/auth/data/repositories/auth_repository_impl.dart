import 'package:blog/Feature/auth/data/datasourse/auth_remote_data_source.dart';
import 'package:blog/Feature/auth/data/models/user_model.dart';
import 'package:blog/core/comman/entities/user.dart';
import 'package:blog/Feature/auth/domain/repository/auth_repository.dart';
import 'package:blog/core/error/exceptions.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/network/connection_cheaker.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionCheaker connectionCheaker;
  const AuthRepositoryImpl(this.remoteDataSource, this.connectionCheaker);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionCheaker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure('user not logged in'));
        }
        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('user not logged in'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(() async => await remoteDataSource.loginWithEmailPassword(
        email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
          name: name, email: email, password: password),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      if (!await (connectionCheaker.isConnected)) {
        return left(Failure('No internet!'));
      }

      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
