import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class UpdateAssetMovementForUserUsecase
    implements
        Usecase<
          ItemSuccess<AssetMovement>,
          UpdateAssetMovementForUserUsecaseParams
        > {
  final AssetMovementRepository _assetMovementRepository;

  UpdateAssetMovementForUserUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> call(
    UpdateAssetMovementForUserUsecaseParams params,
  ) async {
    return await _assetMovementRepository.updateAssetMovementForUser(params);
  }
}

class UpdateAssetMovementForUserUsecaseParams extends Equatable {
  final String id;
  final String? assetId;
  final String? toUserId;
  final String? movedById;
  final DateTime? movementDate;
  final List<UpdateAssetMovementForUserTranslation>? translations;

  UpdateAssetMovementForUserUsecaseParams({
    required this.id,
    this.assetId,
    this.toUserId,
    this.movedById,
    this.movementDate,
    this.translations,
  });

  /// * Factory method to create params with only changed fields
  factory UpdateAssetMovementForUserUsecaseParams.fromChanges({
    required String id,
    required AssetMovement original,
    String? assetId,
    String? toUserId,
    String? movedById,
    DateTime? movementDate,
    List<UpdateAssetMovementForUserTranslation>? translations,
  }) {
    return UpdateAssetMovementForUserUsecaseParams(
      id: id,
      assetId: assetId != original.assetId ? assetId : null,
      toUserId: toUserId != original.toUserId ? toUserId : null,
      movedById: movedById != original.movedById ? movedById : null,
      movementDate: movementDate != original.movementDate ? movementDate : null,
      translations: translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (assetId != null) 'assetId': assetId,
      if (toUserId != null) 'toUserId': toUserId,
      if (movedById != null) 'movedById': movedById,
      if (movementDate != null) 'movementDate': movementDate!.toIso8601String(),
      if (translations != null)
        'translations': translations!.map((x) => x.toMap()).toList(),
    };
  }

  factory UpdateAssetMovementForUserUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateAssetMovementForUserUsecaseParams(
      id: map['id'] ?? '',
      assetId: map['assetId'],
      toUserId: map['toUserId'],
      movedById: map['movedById'],
      movementDate: map['movementDate'] != null
          ? DateTime.parse(map['movementDate'])
          : null,
      translations: map['translations'] != null
          ? List<UpdateAssetMovementForUserTranslation>.from(
              map['translations']?.map(
                    (x) => UpdateAssetMovementForUserTranslation.fromMap(x),
                  ) ??
                  [],
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateAssetMovementForUserUsecaseParams.fromJson(String source) =>
      UpdateAssetMovementForUserUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    id,
    assetId,
    toUserId,
    movedById,
    movementDate,
    translations,
  ];
}

class UpdateAssetMovementForUserTranslation extends Equatable {
  final String langCode;
  final String? notes;

  UpdateAssetMovementForUserTranslation({required this.langCode, this.notes});

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'notes': notes};
  }

  factory UpdateAssetMovementForUserTranslation.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateAssetMovementForUserTranslation(
      langCode: map['langCode'] ?? '',
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateAssetMovementForUserTranslation.fromJson(String source) =>
      UpdateAssetMovementForUserTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, notes];
}
