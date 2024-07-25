import 'package:blog/Feature/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
      required super.id,
      required super.posterId,
      required super.title,
      required super.content,
      required super.imageUrl,
      required super.topics,
      required super.updatesAt
    });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updates_at': updatesAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      title: ['title'] as String,
      content: map['content'] as String,
      imageUrl: ['image_url'] as String,
      topics: List<String>.from(map['topics'] ?? []),
      updatesAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(map['updated_at']),
    );
  }

  BlogModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatesAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId:  posterId ?? this.posterId,
      title:  title ?? this.title,
      content:  content ?? this.content,
      imageUrl:  imageUrl ?? this.imageUrl,
      topics:  topics ?? this.topics,
      updatesAt:  updatesAt ?? this.updatesAt,
    );
  }
}
