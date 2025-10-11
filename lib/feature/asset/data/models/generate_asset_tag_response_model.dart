import 'dart:convert';

import 'package:equatable/equatable.dart';

class GenerateAssetTagResponseModel extends Equatable {
  final String categoryCode;
  final String lastAssetTag;
  final String suggestedTag;
  final int nextIncrement;

  GenerateAssetTagResponseModel({
    required this.categoryCode,
    required this.lastAssetTag,
    required this.suggestedTag,
    required this.nextIncrement,
  });

  @override
  List<Object> get props => [
    categoryCode,
    lastAssetTag,
    suggestedTag,
    nextIncrement,
  ];

  GenerateAssetTagResponseModel copyWith({
    String? categoryCode,
    String? lastAssetTag,
    String? suggestedTag,
    int? nextIncrement,
  }) {
    return GenerateAssetTagResponseModel(
      categoryCode: categoryCode ?? this.categoryCode,
      lastAssetTag: lastAssetTag ?? this.lastAssetTag,
      suggestedTag: suggestedTag ?? this.suggestedTag,
      nextIncrement: nextIncrement ?? this.nextIncrement,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryCode': categoryCode,
      'lastAssetTag': lastAssetTag,
      'suggestedTag': suggestedTag,
      'nextIncrement': nextIncrement,
    };
  }

  factory GenerateAssetTagResponseModel.fromMap(Map<String, dynamic> map) {
    return GenerateAssetTagResponseModel(
      categoryCode: map['categoryCode'] ?? '',
      lastAssetTag: map['lastAssetTag'] ?? '',
      suggestedTag: map['suggestedTag'] ?? '',
      nextIncrement: map['nextIncrement']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenerateAssetTagResponseModel.fromJson(String source) =>
      GenerateAssetTagResponseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GenerateAssetTagResponseModel(categoryCode: $categoryCode, lastAssetTag: $lastAssetTag, suggestedTag: $suggestedTag, nextIncrement: $nextIncrement)';
  }
}
