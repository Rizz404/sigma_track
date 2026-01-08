import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/domain/entities/generate_bulk_asset_tags_response.dart';

class GenerateBulkAssetTagsResponseModel extends Equatable {
  final String categoryCode;
  final String lastAssetTag;
  final String startTag;
  final String endTag;
  final List<String> tags;
  final int quantity;
  final int startIncrement;
  final int endIncrement;

  const GenerateBulkAssetTagsResponseModel({
    required this.categoryCode,
    required this.lastAssetTag,
    required this.startTag,
    required this.endTag,
    required this.tags,
    required this.quantity,
    required this.startIncrement,
    required this.endIncrement,
  });

  GenerateBulkAssetTagsResponseModel copyWith({
    String? categoryCode,
    String? lastAssetTag,
    String? startTag,
    String? endTag,
    List<String>? tags,
    int? quantity,
    int? startIncrement,
    int? endIncrement,
  }) {
    return GenerateBulkAssetTagsResponseModel(
      categoryCode: categoryCode ?? this.categoryCode,
      lastAssetTag: lastAssetTag ?? this.lastAssetTag,
      startTag: startTag ?? this.startTag,
      endTag: endTag ?? this.endTag,
      tags: tags ?? this.tags,
      quantity: quantity ?? this.quantity,
      startIncrement: startIncrement ?? this.startIncrement,
      endIncrement: endIncrement ?? this.endIncrement,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryCode': categoryCode,
      'lastAssetTag': lastAssetTag,
      'startTag': startTag,
      'endTag': endTag,
      'tags': tags,
      'quantity': quantity,
      'startIncrement': startIncrement,
      'endIncrement': endIncrement,
    };
  }

  factory GenerateBulkAssetTagsResponseModel.fromMap(Map<String, dynamic> map) {
    return GenerateBulkAssetTagsResponseModel(
      categoryCode: map['categoryCode'] ?? '',
      lastAssetTag: map['lastAssetTag'] ?? '',
      startTag: map['startTag'] ?? '',
      endTag: map['endTag'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      quantity: map['quantity'] ?? 0,
      startIncrement: map['startIncrement'] ?? 0,
      endIncrement: map['endIncrement'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenerateBulkAssetTagsResponseModel.fromJson(String source) =>
      GenerateBulkAssetTagsResponseModel.fromMap(json.decode(source));

  GenerateBulkAssetTagsResponse toEntity() {
    return GenerateBulkAssetTagsResponse(
      categoryCode: categoryCode,
      lastAssetTag: lastAssetTag,
      startTag: startTag,
      endTag: endTag,
      tags: tags,
      quantity: quantity,
      startIncrement: startIncrement,
      endIncrement: endIncrement,
    );
  }

  @override
  String toString() {
    return 'GenerateBulkAssetTagsResponseModel(categoryCode: $categoryCode, startTag: $startTag, endTag: $endTag, quantity: $quantity)';
  }

  @override
  List<Object> get props => [
    categoryCode,
    lastAssetTag,
    startTag,
    endTag,
    tags,
    quantity,
    startIncrement,
    endIncrement,
  ];
}
