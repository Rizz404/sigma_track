import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class UpdateAssetMovementUsecase
    implements
        Usecase<ItemSuccess<AssetMovement>, UpdateAssetMovementUsecaseParams> {
  final AssetMovementRepository _assetMovementRepository;

  UpdateAssetMovementUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> call(
    UpdateAssetMovementUsecaseParams params,
  ) async {
    return await _assetMovementRepository.updateAssetMovement(params);
  }
}

class UpdateAssetMovementUsecaseParams extends Equatable {
  final String id;
  final String? assetId;
  final String? fromLocationId;
  final String? toLocationId;
  final String? fromUserId;
  final String? toUserId;
  final String? movedById;
  final DateTime? movementDate;
  final List<UpdateAssetMovementTranslation>? translations;

  UpdateAssetMovementUsecaseParams({
    required this.id,
    this.assetId,
    this.fromLocationId,
    this.toLocationId,
    this.fromUserId,
    this.toUserId,
    this.movedById,
    this.movementDate,
    this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (assetId != null) 'assetId': assetId,
      if (fromLocationId != null) 'fromLocationId': fromLocationId,
      if (toLocationId != null) 'toLocationId': toLocationId,
      if (fromUserId != null) 'fromUserId': fromUserId,
      if (toUserId != null) 'toUserId': toUserId,
      if (movedById != null) 'movedById': movedById,
      if (movementDate != null) 'movementDate': movementDate!.toIso8601String(),
      if (translations != null)
        'translations': translations!.map((x) => x.toMap()).toList(),
    };
  }

  factory UpdateAssetMovementUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateAssetMovementUsecaseParams(
      id: map['id'] ?? '',
      assetId: map['assetId'],
      fromLocationId: map['fromLocationId'],
      toLocationId: map['toLocationId'],
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      movedById: map['movedById'],
      movementDate: map['movementDate'] != null
          ? DateTime.parse(map['movementDate'])
          : null,
      translations: map['translations'] != null
          ? List<UpdateAssetMovementTranslation>.from(
              map['translations']?.map(
                    (x) => UpdateAssetMovementTranslation.fromMap(x),
                  ) ??
                  [],
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateAssetMovementUsecaseParams.fromJson(String source) =>
      UpdateAssetMovementUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    id,
    assetId,
    fromLocationId,
    toLocationId,
    fromUserId,
    toUserId,
    movedById,
    movementDate,
    translations,
  ];
}

class UpdateAssetMovementTranslation extends Equatable {
  final String langCode;
  final String? notes;

  UpdateAssetMovementTranslation({required this.langCode, this.notes});

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'notes': notes};
  }

  factory UpdateAssetMovementTranslation.fromMap(Map<String, dynamic> map) {
    return UpdateAssetMovementTranslation(
      langCode: map['langCode'] ?? '',
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateAssetMovementTranslation.fromJson(String source) =>
      UpdateAssetMovementTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, notes];
}
