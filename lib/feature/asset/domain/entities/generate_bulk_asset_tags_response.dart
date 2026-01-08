import 'package:equatable/equatable.dart';

class GenerateBulkAssetTagsResponse extends Equatable {
  final String categoryCode;
  final String lastAssetTag;
  final String startTag;
  final String endTag;
  final List<String> tags;
  final int quantity;
  final int startIncrement;
  final int endIncrement;

  const GenerateBulkAssetTagsResponse({
    required this.categoryCode,
    required this.lastAssetTag,
    required this.startTag,
    required this.endTag,
    required this.tags,
    required this.quantity,
    required this.startIncrement,
    required this.endIncrement,
  });

  GenerateBulkAssetTagsResponse copyWith({
    String? categoryCode,
    String? lastAssetTag,
    String? startTag,
    String? endTag,
    List<String>? tags,
    int? quantity,
    int? startIncrement,
    int? endIncrement,
  }) {
    return GenerateBulkAssetTagsResponse(
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

  @override
  String toString() {
    return 'GenerateBulkAssetTagsResponse(categoryCode: $categoryCode, startTag: $startTag, endTag: $endTag, quantity: $quantity)';
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
