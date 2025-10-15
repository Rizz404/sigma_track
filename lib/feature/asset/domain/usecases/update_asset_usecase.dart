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
  final File? dataMatrixImageFile;
  final String? assetName;
  final String? categoryId;
  final String? brand;
  final String? model;
  final String? serialNumber;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String? vendorName;
  final DateTime? warrantyEnd;
  final AssetStatus? status;
  final AssetCondition? condition;
  final String? locationId;
  final String? assignedTo;

  UpdateAssetUsecaseParams({
    required this.id,
    this.assetTag,
    this.dataMatrixImageFile,
    this.assetName,
    this.categoryId,
    this.brand,
    this.model,
    this.serialNumber,
    this.purchaseDate,
    this.purchasePrice,
    this.vendorName,
    this.warrantyEnd,
    this.status,
    this.condition,
    this.locationId,
    this.assignedTo,
  });

  /// * Factory method to create params with only changed fields
  factory UpdateAssetUsecaseParams.fromChanges({
    required String id,
    required Asset original,
    String? assetTag,
    File? dataMatrixImageFile,
    String? assetName,
    String? categoryId,
    String? brand,
    String? model,
    String? serialNumber,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? vendorName,
    DateTime? warrantyEnd,
    AssetStatus? status,
    AssetCondition? condition,
    String? locationId,
    String? assignedTo,
  }) {
    return UpdateAssetUsecaseParams(
      id: id,
      assetTag: assetTag != original.assetTag ? assetTag : null,
      dataMatrixImageFile: dataMatrixImageFile,
      assetName: assetName != original.assetName ? assetName : null,
      categoryId: categoryId != original.categoryId ? categoryId : null,
      brand: brand != original.brand ? brand : null,
      model: model != original.model ? model : null,
      serialNumber: serialNumber != original.serialNumber ? serialNumber : null,
      purchaseDate: purchaseDate != original.purchaseDate ? purchaseDate : null,
      purchasePrice: purchasePrice != original.purchasePrice
          ? purchasePrice
          : null,
      vendorName: vendorName != original.vendorName ? vendorName : null,
      warrantyEnd: warrantyEnd != original.warrantyEnd ? warrantyEnd : null,
      status: status != original.status ? status : null,
      condition: condition != original.condition ? condition : null,
      locationId: locationId != original.locationId ? locationId : null,
      assignedTo: assignedTo != original.assignedToId ? assignedTo : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (assetTag != null) map['assetTag'] = assetTag;
    if (dataMatrixImageFile != null) {
      map['dataMatrixImageFile'] = dataMatrixImageFile!.path;
    }
    if (assetName != null) map['assetName'] = assetName;
    if (categoryId != null) map['categoryId'] = categoryId;
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
    if (locationId != null) map['locationId'] = locationId;
    if (assignedTo != null) map['assignedTo'] = assignedTo;

    return map;
  }

  factory UpdateAssetUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateAssetUsecaseParams(
      id: map['id'] ?? '',
      assetTag: map['assetTag'],
      dataMatrixImageFile: map['dataMatrixImageFile'] != null
          ? File(map['dataMatrixImageFile'])
          : null,
      assetName: map['assetName'],
      categoryId: map['categoryId'],
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
      locationId: map['locationId'],
      assignedTo: map['assignedTo'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateAssetUsecaseParams.fromJson(String source) =>
      UpdateAssetUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    id,
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
