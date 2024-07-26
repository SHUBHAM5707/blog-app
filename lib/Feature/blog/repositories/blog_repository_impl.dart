import 'dart:io';
import 'package:blog/Feature/blog/data/data%20sources/blog_local_data_source.dart';
import 'package:blog/Feature/blog/data/data%20sources/blog_remote_data_source.dart';
import 'package:blog/Feature/blog/data/model/blog_model.dart';
import 'package:blog/Feature/blog/domain/entities/blog.dart';
import 'package:blog/Feature/blog/domain/repositories/blog_repositories.dart';
import 'package:blog/core/error/exceptions.dart';
import 'package:blog/core/error/failures.dart';
import 'package:blog/core/network/connection_cheaker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionCheaker connectionCheaker;
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionCheaker,
  );

  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      if(!await (connectionCheaker.isConnected)){
        return left(Failure('No connection'));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatesAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if(!await (connectionCheaker.isConnected)){
        final blogs = blogLocalDataSource.localBlog();
        return right(blogs);
      }

      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlog(blogs: blogs);

      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
