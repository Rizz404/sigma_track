import 'dart:convert';

import 'package:equatable/equatable.dart';
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
  final List<AssetMovementTranslationModel> translations;
  final AssetModel asset;
  final LocationModel? fromLocation;
  final LocationModel? toLocation;
  final UserModel? fromUser;
  final UserModel? toUser;
  final UserModel movedBy;

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
    required this.translations,
    required this.asset,
    this.fromLocation,
    this.toLocation,
    this.fromUser,
    this.toUser,
    required this.movedBy,
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
    String? fromLocationId,
    String? toLocationId,
    String? fromUserId,
    String? toUserId,
    String? movedById,
    DateTime? movementDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<AssetMovementTranslationModel>? translations,
    AssetModel? asset,
    LocationModel? fromLocation,
    LocationModel? toLocation,
    UserModel? fromUser,
    UserModel? toUser,
    UserModel? movedBy,
  }) {
    return AssetMovementModel(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      fromLocationId: fromLocationId ?? this.fromLocationId,
      toLocationId: toLocationId ?? this.toLocationId,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      movedById: movedById ?? this.movedById,
      movementDate: movementDate ?? this.movementDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translations: translations ?? this.translations,
      asset: asset ?? this.asset,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
      movedBy: movedBy ?? this.movedBy,
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
      'translations': translations.map((x) => x.toMap()).toList(),
      'asset': asset.toMap(),
      'fromLocation': fromLocation?.toMap(),
      'toLocation': toLocation?.toMap(),
      'fromUser': fromUser?.toMap(),
      'toUser': toUser?.toMap(),
      'movedBy': movedBy.toMap(),
    };
  }

  factory AssetMovementModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementModel(
      id: map['id'] as String,
      assetId: map['assetId'] as String,
      fromLocationId: map['fromLocationId'] as String?,
      toLocationId: map['toLocationId'] as String?,
      fromUserId: map['fromUserId'] as String?,
      toUserId: map['toUserId'] as String?,
      movedById: map['movedById'] as String,
      movementDate: DateTime.fromMillisecondsSinceEpoch(map['movementDate']),
      notes: map['notes'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      translations: List<AssetMovementTranslationModel>.from(
        (map['translations'] as List<dynamic>)
            .map<AssetMovementTranslationModel>(
              (x) => AssetMovementTranslationModel.fromMap(
                x as Map<String, dynamic>,
              ),
            ),
      ),
      asset: AssetModel.fromMap(map['asset'] as Map<String, dynamic>),
      fromLocation: map['fromLocation'] != null
          ? LocationModel.fromMap(map['fromLocation'] as Map<String, dynamic>)
          : null,
      toLocation: map['toLocation'] != null
          ? LocationModel.fromMap(map['toLocation'] as Map<String, dynamic>)
          : null,
      fromUser: map['fromUser'] != null
          ? UserModel.fromMap(map['fromUser'] as Map<String, dynamic>)
          : null,
      toUser: map['toUser'] != null
          ? UserModel.fromMap(map['toUser'] as Map<String, dynamic>)
          : null,
      movedBy: UserModel.fromMap(map['movedBy'] as Map<String, dynamic>),
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

  AssetMovementTranslationModel copyWith({String? langCode, String? notes}) {
    return AssetMovementTranslationModel(
      langCode: langCode ?? this.langCode,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'notes': notes};
  }

  factory AssetMovementTranslationModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementTranslationModel(
      langCode: map['langCode'] as String,
      notes: map['notes'] as String?,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementTranslationModel.fromJson(String source) =>
      AssetMovementTranslationModel.fromMap(jsonDecode(source));

  @override
  String toString() =>
      'AssetMovementTranslationModel(langCode: $langCode, notes: $notes)';
}
