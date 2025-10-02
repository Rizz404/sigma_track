import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class UpdateAssetUsecase
    implements Usecase<ItemSuccess<Asset>, UpdateAssetUsecaseParams> {
  final AssetRepository _assetRepository;

  UpdateAssetUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<Asset>>> call(
    UpdateAssetUsecaseParams params,
  ) async {
    return await _assetRepository.updateAsset(params);
  }
}

class UpdateAssetUsecaseParams extends Equatable {
  final String id;
  final String? assetTag;
  final String? dataMatrixImageUrl;
  final String? assetName;
  final String? categoryID;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String? vendorName;
  final DateTime? warrantyEnd;
  final AssetStatus? status;
  final AssetCondition? condition;
  final String? locationID;
  final String? assignedToID;

  UpdateAssetUsecaseParams({
    required this.id,
    this.assetTag,
    this.dataMatrixImageUrl,
    this.assetName,
    this.categoryID,
    this.brand,
    this.model,
    this.serialNumber,
    this.purchaseDate,
    this.purchasePrice,
    this.vendorName,
    this.warrantyEnd,
    this.status,
    this.condition,
    this.locationID,
    this.assignedToID,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (assetTag != null) map['assetTag'] = assetTag;
    if (dataMatrixImageUrl != null) {
      map['dataMatrixImageUrl'] = dataMatrixImageUrl;
    }
    if (assetName != null) map['assetName'] = assetName;
    if (categoryID != null) map['categoryId'] = categoryID;
    if (brand != null) map['brand'] = brand;
    if (model != null) map['model'] = model;
    if (serialNumber != null) map['serialNumber'] = serialNumber;
    if (purchaseDate != null) {
      map['purchaseDate'] = purchaseDate!.millisecondsSinceEpoch;
    }
    if (purchasePrice != null) map['purchasePrice'] = purchasePrice;
    if (vendorName != null) map['vendorName'] = vendorName;
    if (warrantyEnd != null) {
      map['warrantyEnd'] = warrantyEnd!.millisecondsSinceEpoch;
    }
    if (status != null) map['status'] = status!.toJson();
    if (condition != null) map['condition'] = condition!.toJson();
    if (locationID != null) map['locationId'] = locationID;
    if (assignedToID != null) map['assignedToId'] = assignedToID;

    return map;
  }

  factory UpdateAssetUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateAssetUsecaseParams(
      id: map['id'] ?? '',
      assetTag: map['assetTag'],
      dataMatrixImageUrl: map['dataMatrixImageUrl'],
      assetName: map['assetName'],
      categoryID: map['categoryId'],
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
      status: map['status'] != null
          ? AssetStatus.fromJson(map['status'])
          : null,
      condition: map['condition'] != null
          ? AssetCondition.fromJson(map['condition'])
          : null,
      locationID: map['locationId'],
      assignedToID: map['assignedToId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateAssetUsecaseParams.fromJson(String source) =>
      UpdateAssetUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
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
  ];
}
