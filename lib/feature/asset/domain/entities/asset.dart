import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

class Asset extends Equatable {
  final String id;
  final String assetTag;
  final String dataMatrixImageUrl;
  final String assetName;
  final String categoryId;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String? vendorName;
  final DateTime? warrantyEnd;
  final AssetStatus status;
  final AssetCondition condition;
  final String? locationId;
  final String? assignedToId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category? category;
  final Location? location;
  final User? assignedTo;

  const Asset({
    required this.id,
    required this.assetTag,
    required this.dataMatrixImageUrl,
    required this.assetName,
    required this.categoryId,
    this.brand,
    this.model,
    this.serialNumber,
    this.purchaseDate,
    this.purchasePrice,
    this.vendorName,
    this.warrantyEnd,
    required this.status,
    required this.condition,
    this.locationId,
    this.assignedToId,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.location,
    this.assignedTo,
  });

  @override
  List<Object?> get props {
    return [
      id,
      assetTag,
      dataMatrixImageUrl,
      assetName,
      categoryId,
      brand,
      model,
      serialNumber,
      purchaseDate,
      purchasePrice,
      vendorName,
      warrantyEnd,
      status,
      condition,
      locationId,
      assignedToId,
      createdAt,
      updatedAt,
      category,
      location,
      assignedTo,
    ];
  }
}
