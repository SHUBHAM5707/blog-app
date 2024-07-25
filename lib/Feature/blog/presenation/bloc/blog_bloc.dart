import 'dart:io';

import 'package:blog/Feature/blog/domain/usecase/upload_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;
  BlogBloc(this.uploadBlog) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) => (BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
  }
  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(
        BlogSuccess(),
      ),
    );
  }
}