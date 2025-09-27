import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/category/data/models/category_model.dart';
import 'package:sigma_track/feature/location/data/models/location_model.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

class AssetModel extends Equatable {
  final String id;
  final String assetTag;
  final String dataMatrixImageUrl;
  final String assetName;
  final String categoryID;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String? vendorName;
  final DateTime? warrantyEnd;
  final AssetStatus status;
  final AssetCondition condition;
  final String? locationID;
  final String? assignedToID;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryModel? category;
  final LocationModel? location;
  final UserModel? assignedTo;

  const AssetModel({
    required this.id,
    required this.assetTag,
    required this.dataMatrixImageUrl,
    required this.assetName,
    required this.categoryID,
    this.brand,
    this.model,
    this.serialNumber,
    this.purchaseDate,
    this.purchasePrice,
    this.vendorName,
    this.warrantyEnd,
    required this.status,
    required this.condition,
    this.locationID,
    this.assignedToID,
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
      categoryID,
      brand,
      model,
      serialNumber,
      purchaseDate,
      purchasePrice,
      vendorName,
      warrantyEnd,
      status,
      condition,
      locationID,
      assignedToID,
      createdAt,
      updatedAt,
      category,
      location,
      assignedTo,
    ];
  }

  AssetModel copyWith({
    String? id,
    String? assetTag,
    String? dataMatrixImageUrl,
    String? assetName,
    String? categoryID,
    String? brand,
    String? model,
    String? serialNumber,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? vendorName,
    DateTime? warrantyEnd,
    AssetStatus? status,
    AssetCondition? condition,
    String? locationID,
    String? assignedToID,
    DateTime? createdAt,
    DateTime? updatedAt,
    CategoryModel? category,
    LocationModel? location,
    UserModel? assignedTo,
  }) {
    return AssetModel(
      id: id ?? this.id,
      assetTag: assetTag ?? this.assetTag,
      dataMatrixImageUrl: dataMatrixImageUrl ?? this.dataMatrixImageUrl,
      assetName: assetName ?? this.assetName,
      categoryID: categoryID ?? this.categoryID,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      vendorName: vendorName ?? this.vendorName,
      warrantyEnd: warrantyEnd ?? this.warrantyEnd,
      status: status ?? this.status,
      condition: condition ?? this.condition,
      locationID: locationID ?? this.locationID,
      assignedToID: assignedToID ?? this.assignedToID,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      location: location ?? this.location,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetTag': assetTag,
      'dataMatrixImageUrl': dataMatrixImageUrl,
      'assetName': assetName,
      'categoryId': categoryID,
      'brand': brand,
      'model': model,
      'serialNumber': serialNumber,
      'purchaseDate': purchaseDate?.millisecondsSinceEpoch,
      'purchasePrice': purchasePrice,
      'vendorName': vendorName,
      'warrantyEnd': warrantyEnd?.millisecondsSinceEpoch,
      'status': status.toJson(),
      'condition': condition.toJson(),
      'locationId': locationID,
      'assignedToId': assignedToID,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'category': category?.toMap(),
      'location': location?.toMap(),
      'assignedTo': assignedTo?.toMap(),
    };
  }

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      id: map['id'] ?? '',
      assetTag: map['assetTag'] ?? '',
      dataMatrixImageUrl: map['dataMatrixImageUrl'] ?? '',
      assetName: map['assetName'] ?? '',
      categoryID: map['categoryId'] ?? '',
      brand: map['brand'],
      model: map['model'],
      serialNumber: map['serialNumber'],
      purchaseDate: map['purchaseDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['purchaseDate'])
          : null,
      purchasePrice: map['purchasePrice']?.toDouble(),
      vendorName: map['vendorName'],
      warrantyEnd: map['warrantyEnd'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['warrantyEnd'])
          : null,
      status: AssetStatus.fromJson(map['status']),
      condition: AssetCondition.fromJson(map['condition']),
      locationID: map['locationId'],
      assignedToID: map['assignedToId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      category: map['category'] != null
          ? CategoryModel.fromMap(map['category'])
          : null,
      location: map['location'] != null
          ? LocationModel.fromMap(map['location'])
          : null,
      assignedTo: map['assignedTo'] != null
          ? UserModel.fromMap(map['assignedTo'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetModel.fromJson(String source) =>
      AssetModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AssetModel(id: $id, assetTag: $assetTag, dataMatrixImageUrl: $dataMatrixImageUrl, assetName: $assetName, categoryID: $categoryID, brand: $brand, model: $model, serialNumber: $serialNumber, purchaseDate: $purchaseDate, purchasePrice: $purchasePrice, vendorName: $vendorName, warrantyEnd: $warrantyEnd, status: $status, condition: $condition, locationID: $locationID, assignedToID: $assignedToID, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, location: $location, assignedTo: $assignedTo)';
  }
}
