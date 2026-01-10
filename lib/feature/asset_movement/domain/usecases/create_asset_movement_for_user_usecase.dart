import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class CreateAssetMovementForUserUsecase
    implements
        Usecase<
          ItemSuccess<AssetMovement>,
          CreateAssetMovementForUserUsecaseParams
        > {
  final AssetMovementRepository _assetMovementRepository;

  CreateAssetMovementForUserUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> call(
    CreateAssetMovementForUserUsecaseParams params,
  ) async {
    return await _assetMovementRepository.createAssetMovementForUser(params);
  }
}

class CreateAssetMovementForUserUsecaseParams extends Equatable {
  final String assetId;
  final String? fromUserId;
  final String toUserId;
  final String movedById;
  final DateTime movementDate;
  final List<CreateAssetMovementForUserTranslation> translations;

  CreateAssetMovementForUserUsecaseParams({
    required this.assetId,
    this.fromUserId,
    required this.toUserId,
    required this.movedById,
    required this.movementDate,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      if (fromUserId != null) 'fromUserId': fromUserId,
      'toUserId': toUserId,
      'movedById': movedById,
      'movementDate': movementDate.toIso8601String(),
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateAssetMovementForUserUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return CreateAssetMovementForUserUsecaseParams(
      assetId: map['assetId'] ?? '',
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'] ?? '',
      movedById: map['movedById'] ?? '',
      movementDate: DateTime.parse(map['movementDate']),
      translations: List<CreateAssetMovementForUserTranslation>.from(
        map['translations']?.map(
              (x) => CreateAssetMovementForUserTranslation.fromMap(x),
            ) ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAssetMovementForUserUsecaseParams.fromJson(String source) =>
      CreateAssetMovementForUserUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    assetId,
    fromUserId,
    toUserId,
    movedById,
    movementDate,
    translations,
  ];
}

class CreateAssetMovementForUserTranslation extends Equatable {
  final String langCode;
  final String? notes;

  CreateAssetMovementForUserTranslation({required this.langCode, this.notes});

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'notes': notes};
  }

  factory CreateAssetMovementForUserTranslation.fromMap(
    Map<String, dynamic> map,
  ) {
    return CreateAssetMovementForUserTranslation(
      langCode: map['langCode'] ?? '',
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAssetMovementForUserTranslation.fromJson(String source) =>
      CreateAssetMovementForUserTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, notes];
}
