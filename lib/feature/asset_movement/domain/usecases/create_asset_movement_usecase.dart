import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class CreateAssetMovementUsecase
    implements
        Usecase<ItemSuccess<AssetMovement>, CreateAssetMovementUsecaseParams> {
  final AssetMovementRepository _assetMovementRepository;

  CreateAssetMovementUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> call(
    CreateAssetMovementUsecaseParams params,
  ) async {
    return await _assetMovementRepository.createAssetMovement(params);
  }
}

class CreateAssetMovementUsecaseParams extends Equatable {
  final String assetId;
  final String? fromLocationId;
  final String? toLocationId;
  final String? fromUserId;
  final String? toUserId;
  final String movedById;
  final DateTime movementDate;
  final List<CreateAssetMovementTranslation> translations;

  CreateAssetMovementUsecaseParams({
    required this.assetId,
    this.fromLocationId,
    this.toLocationId,
    this.fromUserId,
    this.toUserId,
    required this.movedById,
    required this.movementDate,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      if (fromLocationId != null) 'fromLocationId': fromLocationId,
      if (toLocationId != null) 'toLocationId': toLocationId,
      if (fromUserId != null) 'fromUserId': fromUserId,
      if (toUserId != null) 'toUserId': toUserId,
      'movedById': movedById,
      'movementDate': movementDate.toIso8601String(),
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateAssetMovementUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CreateAssetMovementUsecaseParams(
      assetId: map['assetId'] ?? '',
      fromLocationId: map['fromLocationId'],
      toLocationId: map['toLocationId'],
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      movedById: map['movedById'] ?? '',
      movementDate: DateTime.parse(map['movementDate']),
      translations: List<CreateAssetMovementTranslation>.from(
        map['translations']?.map(
              (x) => CreateAssetMovementTranslation.fromMap(x),
            ) ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAssetMovementUsecaseParams.fromJson(String source) =>
      CreateAssetMovementUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
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

class CreateAssetMovementTranslation extends Equatable {
  final String langCode;
  final String? notes;

  CreateAssetMovementTranslation({required this.langCode, this.notes});

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'notes': notes};
  }

  factory CreateAssetMovementTranslation.fromMap(Map<String, dynamic> map) {
    return CreateAssetMovementTranslation(
      langCode: map['langCode'] ?? '',
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAssetMovementTranslation.fromJson(String source) =>
      CreateAssetMovementTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, notes];
}
