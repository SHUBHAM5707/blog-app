import 'package:blog/Feature/auth/domain/entities/user.dart';
import 'package:blog/Feature/auth/domain/repository/auth_repository.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User,UserLoginParams>{
    final AuthRepository authRepository;
    const UserLogin(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) {
    return authRepository.loginWithEmailPassword(
      email: params.email, 
      password: params.password
    );
  }

}

class UserLoginParams{
  final String email;
  final String password;

  UserLoginParams({required this.email,required this.password});
  
}