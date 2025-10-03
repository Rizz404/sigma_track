import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class CreateAssetUsecase
    implements Usecase<ItemSuccess<Asset>, CreateAssetUsecaseParams> {
  final AssetRepository _assetRepository;

  CreateAssetUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<Asset>>> call(
    CreateAssetUsecaseParams params,
  ) async {
    return await _assetRepository.createAsset(params);
  }
}

class CreateAssetUsecaseParams extends Equatable {
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

  CreateAssetUsecaseParams({
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
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'assetTag': assetTag,
      'dataMatrixImageUrl': dataMatrixImageUrl,
      'assetName': assetName,
      'categoryId': categoryId,
      'status': status.toJson(),
      'condition': condition.toJson(),
    };

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
    if (locationId != null) map['locationId'] = locationId;
    if (assignedToId != null) map['assignedToId'] = assignedToId;

    return map;
  }

  factory CreateAssetUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CreateAssetUsecaseParams(
      assetTag: map['assetTag'] ?? '',
      dataMatrixImageUrl: map['dataMatrixImageUrl'] ?? '',
      assetName: map['assetName'] ?? '',
      categoryId: map['categoryId'] ?? '',
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
      locationId: map['locationId'],
      assignedToId: map['assignedToId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAssetUsecaseParams.fromJson(String source) =>
      CreateAssetUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
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
  ];
}
