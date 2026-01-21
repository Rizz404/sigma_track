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
  final List<UpdateAssetMovementForLocationTranslation>? translations;

  const UpdateAssetMovementForLocationUsecaseParams({
    required this.id,
    this.translations,
  });

  /// * Factory method to create params with only changed translations
  factory UpdateAssetMovementForLocationUsecaseParams.fromChanges({
    required String id,
    required AssetMovement original,
    List<UpdateAssetMovementForLocationTranslation>? translations,
  }) {
    return UpdateAssetMovementForLocationUsecaseParams(
      id: id,
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
      if (translations != null)
        'translations': translations!.map((x) => x.toMap()).toList(),
    };
  }

  factory UpdateAssetMovementForLocationUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateAssetMovementForLocationUsecaseParams(
      id: map['id'] ?? '',
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
  List<Object?> get props => [id, translations];
}

class UpdateAssetMovementForLocationTranslation extends Equatable {
  final String langCode;
  final String? notes;

  const UpdateAssetMovementForLocationTranslation({
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
