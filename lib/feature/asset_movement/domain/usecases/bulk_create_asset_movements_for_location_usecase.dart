import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_for_location_usecase.dart';

class BulkCreateAssetMovementsForLocationUsecase
    implements
        Usecase<
          ItemSuccess<BulkCreateAssetMovementsForLocationResponse>,
          BulkCreateAssetMovementsForLocationParams
        > {
  final AssetMovementRepository _assetMovementRepository;

  BulkCreateAssetMovementsForLocationUsecase(this._assetMovementRepository);

  @override
  Future<
    Either<Failure, ItemSuccess<BulkCreateAssetMovementsForLocationResponse>>
  >
  call(BulkCreateAssetMovementsForLocationParams params) async {
    return await _assetMovementRepository.createManyAssetMovementsForLocation(
      params,
    );
  }
}

class BulkCreateAssetMovementsForLocationParams extends Equatable {
  final List<CreateAssetMovementForLocationUsecaseParams> assetMovements;

  const BulkCreateAssetMovementsForLocationParams({
    required this.assetMovements,
  });

  Map<String, dynamic> toMap() {
    return {'assetMovements': assetMovements.map((x) => x.toMap()).toList()};
  }

  factory BulkCreateAssetMovementsForLocationParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return BulkCreateAssetMovementsForLocationParams(
      assetMovements: List<CreateAssetMovementForLocationUsecaseParams>.from(
        (map['assetMovements'] as List).map(
          (x) => CreateAssetMovementForLocationUsecaseParams.fromMap(
            x as Map<String, dynamic>,
          ),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateAssetMovementsForLocationParams.fromJson(String source) =>
      BulkCreateAssetMovementsForLocationParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [assetMovements];
}

class BulkCreateAssetMovementsForLocationResponse extends Equatable {
  final List<AssetMovement> assetMovements;

  const BulkCreateAssetMovementsForLocationResponse({
    required this.assetMovements,
  });

  Map<String, dynamic> toMap() {
    return {
      'assetMovements': assetMovements
          .map((x) => _assetMovementToMap(x))
          .toList(),
    };
  }

  factory BulkCreateAssetMovementsForLocationResponse.fromMap(
    Map<String, dynamic> map,
  ) {
    return BulkCreateAssetMovementsForLocationResponse(
      assetMovements: List<AssetMovement>.from(
        (map['assetMovements'] as List).map(
          (x) => _assetMovementFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateAssetMovementsForLocationResponse.fromJson(String source) =>
      BulkCreateAssetMovementsForLocationResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [assetMovements];

  static Map<String, dynamic> _assetMovementToMap(AssetMovement assetMovement) {
    return {
      'id': assetMovement.id,
      'assetId': assetMovement.assetId,
      'fromLocationId': assetMovement.fromLocationId,
      'toLocationId': assetMovement.toLocationId,
      'fromUserId': assetMovement.fromUserId,
      'toUserId': assetMovement.toUserId,
      'movedById': assetMovement.movedById,
      'movementDate': assetMovement.movementDate.toIso8601String(),
      'notes': assetMovement.notes,
      'createdAt': assetMovement.createdAt.toIso8601String(),
      'updatedAt': assetMovement.updatedAt.toIso8601String(),
    };
  }

  static AssetMovement _assetMovementFromMap(Map<String, dynamic> map) {
    return AssetMovement(
      id: map['id'] ?? '',
      assetId: map['assetId'] ?? '',
      fromLocationId: map['fromLocationId'],
      toLocationId: map['toLocationId'],
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      movedById: map['movedById'] ?? '',
      movementDate: DateTime.parse(map['movementDate'].toString()),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
      movedBy: null,
    );
  }
}
