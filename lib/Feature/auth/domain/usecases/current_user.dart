import 'package:blog/core/comman/entities/user.dart';
import 'package:blog/Feature/auth/domain/repository/auth_repository.dart';
import 'package:blog/Feature/auth/presentation/bloc/auth_bloc_bloc.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, Noparams>{
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(Noparams params) async{
    return await authRepository.currentUser();
  }

  registerLazySingleton(AuthBloc Function() param0) {}
  
}