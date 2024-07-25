import 'package:blog/Feature/blog/domain/entities/blog.dart';
import 'package:blog/Feature/blog/domain/repositories/blog_repositories.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>,Noparams>{
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);


  @override
  Future<Either<Failure, List<Blog>>> call(Noparams params) async{
    return await blogRepository.getAllBlogs();
  }
}