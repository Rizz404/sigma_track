import 'package:equatable/equatable.dart';

class GenerateAssetTagResponse extends Equatable {
  final String categoryCode;
  final String lastAssetTag;
  final String suggestedTag;
  final int nextIncrement;

  GenerateAssetTagResponse({
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
}
