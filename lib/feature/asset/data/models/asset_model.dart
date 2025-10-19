import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/feature/category/data/models/category_model.dart';
import 'package:sigma_track/feature/location/data/models/location_model.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

class AssetModel extends Equatable {
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
  final CategoryModel? category;
  final LocationModel? location;
  final UserModel? assignedTo;

  const AssetModel({
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

  AssetModel copyWith({
    String? id,
    String? assetTag,
    String? dataMatrixImageUrl,
    String? assetName,
    String? categoryId,
    ValueGetter<String?>? brand,
    ValueGetter<String?>? model,
    ValueGetter<String?>? serialNumber,
    ValueGetter<DateTime?>? purchaseDate,
    ValueGetter<double?>? purchasePrice,
    ValueGetter<String?>? vendorName,
    ValueGetter<DateTime?>? warrantyEnd,
    AssetStatus? status,
    AssetCondition? condition,
    ValueGetter<String?>? locationId,
    ValueGetter<String?>? assignedToId,
    DateTime? createdAt,
    DateTime? updatedAt,
    ValueGetter<CategoryModel?>? category,
    ValueGetter<LocationModel?>? location,
    ValueGetter<UserModel?>? assignedTo,
  }) {
    return AssetModel(
      id: id ?? this.id,
      assetTag: assetTag ?? this.assetTag,
      dataMatrixImageUrl: dataMatrixImageUrl ?? this.dataMatrixImageUrl,
      assetName: assetName ?? this.assetName,
      categoryId: categoryId ?? this.categoryId,
      brand: brand != null ? brand() : this.brand,
      model: model != null ? model() : this.model,
      serialNumber: serialNumber != null ? serialNumber() : this.serialNumber,
      purchaseDate: purchaseDate != null ? purchaseDate() : this.purchaseDate,
      purchasePrice: purchasePrice != null
          ? purchasePrice()
          : this.purchasePrice,
      vendorName: vendorName != null ? vendorName() : this.vendorName,
      warrantyEnd: warrantyEnd != null ? warrantyEnd() : this.warrantyEnd,
      status: status ?? this.status,
      condition: condition ?? this.condition,
      locationId: locationId != null ? locationId() : this.locationId,
      assignedToId: assignedToId != null ? assignedToId() : this.assignedToId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category != null ? category() : this.category,
      location: location != null ? location() : this.location,
      assignedTo: assignedTo != null ? assignedTo() : this.assignedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetTag': assetTag,
      'dataMatrixImageUrl': dataMatrixImageUrl,
      'assetName': assetName,
      'categoryId': categoryId,
      'brand': brand,
      'model': model,
      'serialNumber': serialNumber,
      'purchaseDate': purchaseDate?.millisecondsSinceEpoch,
      'purchasePrice': purchasePrice,
      'vendorName': vendorName,
      'warrantyEnd': warrantyEnd?.millisecondsSinceEpoch,
      'status': status.value,
      'condition': condition.value,
      'locationId': locationId,
      'assignedToId': assignedToId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'category': category?.toMap(),
      'location': location?.toMap(),
      'assignedTo': assignedTo?.toMap(),
    };
  }

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      id: map.getField<String>('id'),
      assetTag: map.getField<String>('assetTag'),
      dataMatrixImageUrl: map.getField<String>('dataMatrixImageUrl'),
      assetName: map.getField<String>('assetName'),
      categoryId: map.getField<String>('categoryId'),
      brand: map.getFieldOrNull<String>('brand'),
      model: map.getFieldOrNull<String>('model'),
      serialNumber: map.getFieldOrNull<String>('serialNumber'),
      purchaseDate: map.getFieldOrNull<DateTime>('purchaseDate'),
      purchasePrice: map.getFieldOrNull<double>('purchasePrice'),
      vendorName: map.getFieldOrNull<String>('vendorName'),
      warrantyEnd: map.getFieldOrNull<DateTime>('warrantyEnd'),
      status: AssetStatus.values.firstWhere(
        (e) => e.value == map.getField<String>('status'),
      ),
      condition: AssetCondition.values.firstWhere(
        (e) => e.value == map.getField<String>('condition'),
      ),
      locationId: map.getFieldOrNull<String>('locationId'),
      assignedToId: map.getFieldOrNull<String>('assignedToId'),
      createdAt: map.getField<DateTime>('createdAt'),
      updatedAt: map.getField<DateTime>('updatedAt'),
      category: map.getFieldOrNull<Map<String, dynamic>>('category') != null
          ? CategoryModel.fromMap(
              map.getField<Map<String, dynamic>>('category'),
            )
          : null,
      location: map.getFieldOrNull<Map<String, dynamic>>('location') != null
          ? LocationModel.fromMap(
              map.getField<Map<String, dynamic>>('location'),
            )
          : null,
      assignedTo: map.getFieldOrNull<Map<String, dynamic>>('assignedTo') != null
          ? UserModel.fromMap(map.getField<Map<String, dynamic>>('assignedTo'))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetModel.fromJson(String source) =>
      AssetModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AssetModel(id: $id, assetTag: $assetTag, dataMatrixImageUrl: $dataMatrixImageUrl, assetName: $assetName, categoryId: $categoryId, brand: $brand, model: $model, serialNumber: $serialNumber, purchaseDate: $purchaseDate, purchasePrice: $purchasePrice, vendorName: $vendorName, warrantyEnd: $warrantyEnd, status: $status, condition: $condition, locationId: $locationId, assignedToId: $assignedToId, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, location: $location, assignedTo: $assignedTo)';
  }
}
