import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class AssetImageModel extends Equatable {
  final String id;
  final String imageUrl;
  final int displayOrder;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssetImageModel({
    required this.id,
    required this.imageUrl,
    required this.displayOrder,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [id, imageUrl, displayOrder, isPrimary, createdAt, updatedAt];
  }

  AssetImageModel copyWith({
    String? id,
    String? imageUrl,
    int? displayOrder,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssetImageModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'displayOrder': displayOrder,
      'isPrimary': isPrimary,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory AssetImageModel.fromMap(Map<String, dynamic> map) {
    return AssetImageModel(
      id: map.getField<String>('id'),
      imageUrl: map.getField<String>('imageUrl'),
      displayOrder: map.getField<int>('displayOrder'),
      isPrimary: map.getField<bool>('isPrimary'),
      createdAt: map.getField<DateTime>('createdAt'),
      updatedAt: map.getField<DateTime>('updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetImageModel.fromJson(String source) =>
      AssetImageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AssetImageModel(id: $id, imageUrl: $imageUrl, displayOrder: $displayOrder, isPrimary: $isPrimary, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
