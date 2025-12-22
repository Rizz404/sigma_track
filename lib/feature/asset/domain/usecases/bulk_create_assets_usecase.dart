import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';

class BulkCreateAssetsUsecase
    implements
        Usecase<ItemSuccess<BulkCreateAssetsResponse>, BulkCreateAssetsParams> {
  final AssetRepository _assetRepository;

  BulkCreateAssetsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateAssetsResponse>>> call(
    BulkCreateAssetsParams params,
  ) async {
    return await _assetRepository.createManyAssets(params);
  }
}

class BulkCreateAssetsParams extends Equatable {
  final List<CreateAssetUsecaseParams> assets;

  const BulkCreateAssetsParams({required this.assets});

  Map<String, dynamic> toMap() {
    return {'assets': assets.map((x) => x.toMap()).toList()};
  }

  factory BulkCreateAssetsParams.fromMap(Map<String, dynamic> map) {
    return BulkCreateAssetsParams(
      assets: List<CreateAssetUsecaseParams>.from(
        (map['assets'] as List).map(
          (x) => CreateAssetUsecaseParams.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateAssetsParams.fromJson(String source) =>
      BulkCreateAssetsParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [assets];
}

class BulkCreateAssetsResponse extends Equatable {
  final List<Asset> assets;

  const BulkCreateAssetsResponse({required this.assets});

  Map<String, dynamic> toMap() {
    return {'assets': assets.map((x) => _assetToMap(x)).toList()};
  }

  factory BulkCreateAssetsResponse.fromMap(Map<String, dynamic> map) {
    return BulkCreateAssetsResponse(
      assets: List<Asset>.from(
        (map['assets'] as List).map(
          (x) => _assetFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateAssetsResponse.fromJson(String source) =>
      BulkCreateAssetsResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [assets];

  static Map<String, dynamic> _assetToMap(Asset asset) {
    return {
      'id': asset.id,
      'assetTag': asset.assetTag,
      'dataMatrixImageUrl': asset.dataMatrixImageUrl,
      'assetName': asset.assetName,
      'categoryId': asset.categoryId,
      'brand': asset.brand,
      'model': asset.model,
      'serialNumber': asset.serialNumber,
      'purchaseDate': asset.purchaseDate?.toIso8601String(),
      'purchasePrice': asset.purchasePrice,
      'vendorName': asset.vendorName,
      'warrantyEnd': asset.warrantyEnd?.toIso8601String(),
      'status': asset.status.value,
      'condition': asset.condition.value,
      'locationId': asset.locationId,
      'assignedToId': asset.assignedToId,
      'createdAt': asset.createdAt.toIso8601String(),
      'updatedAt': asset.updatedAt.toIso8601String(),
    };
  }

  static Asset _assetFromMap(Map<String, dynamic> map) {
    return Asset(
      id: map['id'] ?? '',
      assetTag: map['assetTag'] ?? '',
      dataMatrixImageUrl: map['dataMatrixImageUrl'] ?? '',
      assetName: map['assetName'] ?? '',
      categoryId: map['categoryId'] ?? '',
      brand: map['brand'],
      model: map['model'],
      serialNumber: map['serialNumber'],
      purchaseDate: map['purchaseDate'] != null
          ? DateTime.parse(map['purchaseDate'].toString())
          : null,
      purchasePrice: map['purchasePrice']?.toDouble(),
      vendorName: map['vendorName'],
      warrantyEnd: map['warrantyEnd'] != null
          ? DateTime.parse(map['warrantyEnd'].toString())
          : null,
      status: AssetStatus.values.firstWhere(
        (e) => e.value == map['status'],
        orElse: () => AssetStatus.active,
      ),
      condition: AssetCondition.values.firstWhere(
        (e) => e.value == map['condition'],
        orElse: () => AssetCondition.good,
      ),
      locationId: map['locationId'],
      assignedToId: map['assignedToId'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
    );
  }
}
