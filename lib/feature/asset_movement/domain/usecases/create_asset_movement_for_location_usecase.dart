import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class CreateAssetMovementForLocationUsecase
    implements
        Usecase<
          ItemSuccess<AssetMovement>,
          CreateAssetMovementForLocationUsecaseParams
        > {
  final AssetMovementRepository _assetMovementRepository;

  CreateAssetMovementForLocationUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> call(
    CreateAssetMovementForLocationUsecaseParams params,
  ) async {
    return await _assetMovementRepository.createAssetMovementForLocation(
      params,
    );
  }
}

class CreateAssetMovementForLocationUsecaseParams extends Equatable {
  final String assetId;
  final String? fromLocationId;
  final String toLocationId;
  final String movedById;
  final DateTime movementDate;
  final List<CreateAssetMovementForLocationTranslation> translations;

  CreateAssetMovementForLocationUsecaseParams({
    required this.assetId,
    this.fromLocationId,
    required this.toLocationId,
    required this.movedById,
    required this.movementDate,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      if (fromLocationId != null) 'fromLocationId': fromLocationId,
      'toLocationId': toLocationId,
      'movedById': movedById,
      'movementDate': movementDate.toIso8601String(),
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateAssetMovementForLocationUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return CreateAssetMovementForLocationUsecaseParams(
      assetId: map['assetId'] ?? '',
      fromLocationId: map['fromLocationId'],
      toLocationId: map['toLocationId'] ?? '',
      movedById: map['movedById'] ?? '',
      movementDate: DateTime.parse(map['movementDate']),
      translations: List<CreateAssetMovementForLocationTranslation>.from(
        map['translations']?.map(
              (x) => CreateAssetMovementForLocationTranslation.fromMap(x),
            ) ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAssetMovementForLocationUsecaseParams.fromJson(String source) =>
      CreateAssetMovementForLocationUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    assetId,
    fromLocationId,
    toLocationId,
    movedById,
    movementDate,
    translations,
  ];
}

class CreateAssetMovementForLocationTranslation extends Equatable {
  final String langCode;
  final String? notes;

  CreateAssetMovementForLocationTranslation({
    required this.langCode,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'notes': notes};
  }

  factory CreateAssetMovementForLocationTranslation.fromMap(
    Map<String, dynamic> map,
  ) {
    return CreateAssetMovementForLocationTranslation(
      langCode: map['langCode'] ?? '',
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAssetMovementForLocationTranslation.fromJson(String source) =>
      CreateAssetMovementForLocationTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, notes];
}
