import 'package:blog/core/comman/entities/user.dart';
import 'package:blog/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository{
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password
  });

  Future<Either<Failure,User>> currentUser();
}