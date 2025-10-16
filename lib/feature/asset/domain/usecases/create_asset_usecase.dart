import 'dart:convert';
import 'dart:io';

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
  final File? dataMatrixImageFile;
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
  final String? assignedTo;

  CreateAssetUsecaseParams({
    required this.assetTag,
    this.dataMatrixImageFile,
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
    this.assignedTo,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'assetTag': assetTag,
      if (dataMatrixImageFile != null)
        'dataMatrixImageFile': dataMatrixImageFile!.path,
      'assetName': assetName,
      'categoryId': categoryId,
      'status': status.value,
      'condition': condition.value,
    };

    if (brand != null) map['brand'] = brand;
    if (model != null) map['model'] = model;
    if (serialNumber != null) map['serialNumber'] = serialNumber;
    if (purchaseDate != null) {
      map['purchaseDate'] = purchaseDate!.toIso8601String().split('T').first;
    }
    if (purchasePrice != null) map['purchasePrice'] = purchasePrice;
    if (vendorName != null) map['vendorName'] = vendorName;
    if (warrantyEnd != null) {
      map['warrantyEnd'] = warrantyEnd!.toIso8601String().split('T').first;
    }
    if (locationId != null) map['locationId'] = locationId;
    if (assignedTo != null) map['assignedTo'] = assignedTo;

    return map;
  }

  factory CreateAssetUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CreateAssetUsecaseParams(
      assetTag: map['assetTag'] ?? '',
      dataMatrixImageFile: map['dataMatrixImageFile'] != null
          ? File(map['dataMatrixImageFile'])
          : null,
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
      status: AssetStatus.values.firstWhere((e) => e.value == map['status']),
      condition: AssetCondition.values.firstWhere(
        (e) => e.value == map['condition'],
      ),
      locationId: map['locationId'],
      assignedTo: map['assignedTo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAssetUsecaseParams.fromJson(String source) =>
      CreateAssetUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    assetTag,
    dataMatrixImageFile,
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
    assignedTo,
  ];
}
