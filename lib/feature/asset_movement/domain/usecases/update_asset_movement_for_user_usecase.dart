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
  final List<UpdateAssetMovementForUserTranslation>? translations;

  const UpdateAssetMovementForUserUsecaseParams({
    required this.id,
    this.translations,
  });

  /// * Factory method to create params with only changed translations
  factory UpdateAssetMovementForUserUsecaseParams.fromChanges({
    required String id,
    required AssetMovement original,
    List<UpdateAssetMovementForUserTranslation>? translations,
  }) {
    return UpdateAssetMovementForUserUsecaseParams(
      id: id,
      translations: _areTranslationsEqual(original.translations, translations)
          ? null
          : translations,
    );
  }

  /// * Helper method to compare translations
  static bool _areTranslationsEqual(
    List<AssetMovementTranslation>? original,
    List<UpdateAssetMovementForUserTranslation>? updated,
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

  factory UpdateAssetMovementForUserUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateAssetMovementForUserUsecaseParams(
      id: map['id'] ?? '',
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
  List<Object?> get props => [id, translations];
}

class UpdateAssetMovementForUserTranslation extends Equatable {
  final String langCode;
  final String? notes;

  const UpdateAssetMovementForUserTranslation({
    required this.langCode,
    this.notes,
  });

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
