import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class UpdateAssetMovementForLocationUsecase
    implements
        Usecase<
          ItemSuccess<AssetMovement>,
          UpdateAssetMovementForLocationUsecaseParams
        > {
  final AssetMovementRepository _assetMovementRepository;

  UpdateAssetMovementForLocationUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> call(
    UpdateAssetMovementForLocationUsecaseParams params,
  ) async {
    return await _assetMovementRepository.updateAssetMovementForLocation(
      params,
    );
  }
}

class UpdateAssetMovementForLocationUsecaseParams extends Equatable {
  final String id;
  final String? assetId;
  final String? fromLocationId;
  final String? toLocationId;
  final String? movedById;
  final DateTime? movementDate;
  final List<UpdateAssetMovementForLocationTranslation>? translations;

  UpdateAssetMovementForLocationUsecaseParams({
    required this.id,
    this.assetId,
    this.fromLocationId,
    this.toLocationId,
    this.movedById,
    this.movementDate,
    this.translations,
  });

  /// * Factory method to create params with only changed fields
  factory UpdateAssetMovementForLocationUsecaseParams.fromChanges({
    required String id,
    required AssetMovement original,
    String? assetId,
    String? fromLocationId,
    String? toLocationId,
    String? movedById,
    DateTime? movementDate,
    List<UpdateAssetMovementForLocationTranslation>? translations,
  }) {
    return UpdateAssetMovementForLocationUsecaseParams(
      id: id,
      assetId: assetId != original.assetId ? assetId : null,
      fromLocationId: fromLocationId != original.fromLocationId
          ? fromLocationId
          : null,
      toLocationId: toLocationId != original.toLocationId ? toLocationId : null,
      movedById: movedById != original.movedById ? movedById : null,
      movementDate: movementDate != original.movementDate ? movementDate : null,
      translations: _areTranslationsEqual(original.translations, translations)
          ? null
          : translations,
    );
  }

  /// * Helper method to compare translations
  static bool _areTranslationsEqual(
    List<AssetMovementTranslation>? original,
    List<UpdateAssetMovementForLocationTranslation>? updated,
  ) {
    if (updated == null) return true;
    if (original == null || original.length != updated.length) return false;

    for (final upd in updated) {
      final orig = original.cast<AssetMovementTranslation?>().firstWhere(
        (o) => o?.langCode == upd.langCode,
        orElse: () => null,
      );
      if (orig == null) return false;
      if (orig.notes != upd.notes) return false;
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (assetId != null) 'assetId': assetId,
      if (fromLocationId != null) 'fromLocationId': fromLocationId,
      if (toLocationId != null) 'toLocationId': toLocationId,
      if (movedById != null) 'movedById': movedById,
      if (movementDate != null) 'movementDate': movementDate!.toIso8601String(),
      if (translations != null)
        'translations': translations!.map((x) => x.toMap()).toList(),
    };
  }

  factory UpdateAssetMovementForLocationUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateAssetMovementForLocationUsecaseParams(
      id: map['id'] ?? '',
      assetId: map['assetId'],
      fromLocationId: map['fromLocationId'],
      toLocationId: map['toLocationId'],
      movedById: map['movedById'],
      movementDate: map['movementDate'] != null
          ? DateTime.parse(map['movementDate'])
          : null,
      translations: map['translations'] != null
          ? List<UpdateAssetMovementForLocationTranslation>.from(
              map['translations']?.map(
                    (x) => UpdateAssetMovementForLocationTranslation.fromMap(x),
                  ) ??
                  [],
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateAssetMovementForLocationUsecaseParams.fromJson(String source) =>
      UpdateAssetMovementForLocationUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    id,
    assetId,
    fromLocationId,
    toLocationId,
    movedById,
    movementDate,
    translations,
  ];
}

class UpdateAssetMovementForLocationTranslation extends Equatable {
  final String langCode;
  final String? notes;

  UpdateAssetMovementForLocationTranslation({
    required this.langCode,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'notes': notes};
  }

  factory UpdateAssetMovementForLocationTranslation.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateAssetMovementForLocationTranslation(
      langCode: map['langCode'] ?? '',
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateAssetMovementForLocationTranslation.fromJson(String source) =>
      UpdateAssetMovementForLocationTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, notes];
}
