import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/location/data/models/location_model.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

class AssetMovementModel extends Equatable {
  final String id;
  final String assetID;
  final String? fromLocationID;
  final String? toLocationID;
  final String? fromUserID;
  final String? toUserID;
  final String movedByID;
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
    required this.assetID,
    this.fromLocationID,
    this.toLocationID,
    this.fromUserID,
    this.toUserID,
    required this.movedByID,
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
    assetID,
    fromLocationID,
    toLocationID,
    fromUserID,
    toUserID,
    movedByID,
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
    String? assetID,
    String? fromLocationID,
    String? toLocationID,
    String? fromUserID,
    String? toUserID,
    String? movedByID,
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
      assetID: assetID ?? this.assetID,
      fromLocationID: fromLocationID ?? this.fromLocationID,
      toLocationID: toLocationID ?? this.toLocationID,
      fromUserID: fromUserID ?? this.fromUserID,
      toUserID: toUserID ?? this.toUserID,
      movedByID: movedByID ?? this.movedByID,
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
      'assetId': assetID,
      'fromLocationId': fromLocationID,
      'toLocationId': toLocationID,
      'fromUserId': fromUserID,
      'toUserId': toUserID,
      'movedById': movedByID,
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
      assetID: map['assetId'] as String,
      fromLocationID: map['fromLocationId'] as String?,
      toLocationID: map['toLocationId'] as String?,
      fromUserID: map['fromUserId'] as String?,
      toUserID: map['toUserId'] as String?,
      movedByID: map['movedById'] as String,
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
}

class AssetMovementTranslationModel {
  final String langCode;
  final String? notes;

  const AssetMovementTranslationModel({required this.langCode, this.notes});

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
}
