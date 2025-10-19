import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/location/data/models/location_model.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

class AssetMovementModel extends Equatable {
  final String id;
  final String assetId;
  final String? fromLocationId;
  final String? toLocationId;
  final String? fromUserId;
  final String? toUserId;
  final String movedById;
  final DateTime movementDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AssetMovementTranslationModel>? translations;
  final AssetModel? asset;
  final LocationModel? fromLocation;
  final LocationModel? toLocation;
  final UserModel? fromUser;
  final UserModel? toUser;
  final UserModel? movedBy;

  const AssetMovementModel({
    required this.id,
    required this.assetId,
    this.fromLocationId,
    this.toLocationId,
    this.fromUserId,
    this.toUserId,
    required this.movedById,
    required this.movementDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.translations,
    this.asset,
    this.fromLocation,
    this.toLocation,
    this.fromUser,
    this.toUser,
    this.movedBy,
  });

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
    notes,
    createdAt,
    updatedAt,
    translations,
    asset,
    fromLocation,
    toLocation,
    fromUser,
    toUser,
    movedBy,
  ];

  AssetMovementModel copyWith({
    String? id,
    String? assetId,
    ValueGetter<String?>? fromLocationId,
    ValueGetter<String?>? toLocationId,
    ValueGetter<String?>? fromUserId,
    ValueGetter<String?>? toUserId,
    String? movedById,
    DateTime? movementDate,
    ValueGetter<String?>? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    ValueGetter<List<AssetMovementTranslationModel>?>? translations,
    ValueGetter<AssetModel?>? asset,
    ValueGetter<LocationModel?>? fromLocation,
    ValueGetter<LocationModel?>? toLocation,
    ValueGetter<UserModel?>? fromUser,
    ValueGetter<UserModel?>? toUser,
    ValueGetter<UserModel?>? movedBy,
  }) {
    return AssetMovementModel(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      fromLocationId: fromLocationId != null
          ? fromLocationId()
          : this.fromLocationId,
      toLocationId: toLocationId != null ? toLocationId() : this.toLocationId,
      fromUserId: fromUserId != null ? fromUserId() : this.fromUserId,
      toUserId: toUserId != null ? toUserId() : this.toUserId,
      movedById: movedById ?? this.movedById,
      movementDate: movementDate ?? this.movementDate,
      notes: notes != null ? notes() : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translations: translations != null ? translations() : this.translations,
      asset: asset != null ? asset() : this.asset,
      fromLocation: fromLocation != null ? fromLocation() : this.fromLocation,
      toLocation: toLocation != null ? toLocation() : this.toLocation,
      fromUser: fromUser != null ? fromUser() : this.fromUser,
      toUser: toUser != null ? toUser() : this.toUser,
      movedBy: movedBy != null ? movedBy() : this.movedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetId': assetId,
      'fromLocationId': fromLocationId,
      'toLocationId': toLocationId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'movedById': movedById,
      'movementDate': movementDate.millisecondsSinceEpoch,
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'translations': translations?.map((x) => x.toMap()).toList() ?? [],
      'asset': asset?.toMap(),
      'fromLocation': fromLocation?.toMap(),
      'toLocation': toLocation?.toMap(),
      'fromUser': fromUser?.toMap(),
      'toUser': toUser?.toMap(),
      'movedBy': movedBy?.toMap(),
    };
  }

  factory AssetMovementModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementModel(
      id: map.getField<String>('id'),
      assetId: map.getField<String>('assetId'),
      fromLocationId: map.getFieldOrNull<String>('fromLocationId'),
      toLocationId: map.getFieldOrNull<String>('toLocationId'),
      fromUserId: map.getFieldOrNull<String>('fromUserId'),
      toUserId: map.getFieldOrNull<String>('toUserId'),
      movedById: map.getField<String>('movedById'),
      movementDate: map.getField<DateTime>('movementDate'),
      notes: map.getFieldOrNull<String>('notes'),
      createdAt: map.getField<DateTime>('createdAt'),
      updatedAt: map.getField<DateTime>('updatedAt'),
      translations: List<AssetMovementTranslationModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('translations')
                ?.map<AssetMovementTranslationModel>(
                  (x) => AssetMovementTranslationModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
      asset: map.getFieldOrNull<Map<String, dynamic>>('fromLocation') != null
          ? AssetModel.fromMap(map.getField<Map<String, dynamic>>('asset'))
          : null,
      fromLocation:
          map.getFieldOrNull<Map<String, dynamic>>('fromLocation') != null
          ? LocationModel.fromMap(
              map.getField<Map<String, dynamic>>('fromLocation'),
            )
          : null,
      toLocation: map.getFieldOrNull<Map<String, dynamic>>('toLocation') != null
          ? LocationModel.fromMap(
              map.getField<Map<String, dynamic>>('toLocation'),
            )
          : null,
      fromUser: map.getFieldOrNull<Map<String, dynamic>>('fromUser') != null
          ? UserModel.fromMap(map.getField<Map<String, dynamic>>('fromUser'))
          : null,
      toUser: map.getFieldOrNull<Map<String, dynamic>>('toUser') != null
          ? UserModel.fromMap(map.getField<Map<String, dynamic>>('toUser'))
          : null,
      movedBy: map.getFieldOrNull<Map<String, dynamic>>('movedBy') != null
          ? UserModel.fromMap(map.getField<Map<String, dynamic>>('movedBy'))
          : null,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementModel.fromJson(String source) =>
      AssetMovementModel.fromMap(jsonDecode(source));

  @override
  String toString() {
    return 'AssetMovementModel(id: $id, assetId: $assetId, fromLocationId: $fromLocationId, toLocationId: $toLocationId, fromUserId: $fromUserId, toUserId: $toUserId, movedById: $movedById, movementDate: $movementDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations, asset: $asset, fromLocation: $fromLocation, toLocation: $toLocation, fromUser: $fromUser, toUser: $toUser, movedBy: $movedBy)';
  }
}

class AssetMovementTranslationModel extends Equatable {
  final String langCode;
  final String? notes;

  const AssetMovementTranslationModel({required this.langCode, this.notes});

  @override
  List<Object?> get props => [langCode, notes];

  AssetMovementTranslationModel copyWith({
    String? langCode,
    ValueGetter<String?>? notes,
  }) {
    return AssetMovementTranslationModel(
      langCode: langCode ?? this.langCode,
      notes: notes != null ? notes() : this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'notes': notes};
  }

  factory AssetMovementTranslationModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementTranslationModel(
      langCode: map.getField<String>('langCode'),
      notes: map.getFieldOrNull<String>('notes'),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementTranslationModel.fromJson(String source) =>
      AssetMovementTranslationModel.fromMap(jsonDecode(source));

  @override
  String toString() =>
      'AssetMovementTranslationModel(langCode: $langCode, notes: $notes)';
}
