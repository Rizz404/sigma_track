import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class ImageResponseModel extends Equatable {
  final String id;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ImageResponseModel({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, imageUrl, createdAt, updatedAt];

  ImageResponseModel copyWith({
    String? id,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ImageResponseModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ImageResponseModel.fromMap(Map<String, dynamic> map) {
    return ImageResponseModel(
      id: map.getField<String>('id'),
      imageUrl: map.getField<String>('imageUrl'),
      createdAt: map.getField<DateTime>('createdAt'),
      updatedAt: map.getField<DateTime>('updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageResponseModel.fromJson(String source) =>
      ImageResponseModel.fromMap(json.decode(source));
}
