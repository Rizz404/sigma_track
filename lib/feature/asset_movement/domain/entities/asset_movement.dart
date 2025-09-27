import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

class AssetMovement extends Equatable {
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
  final List<AssetMovementTranslation> translations;
  final Asset asset;
  final Location? fromLocation;
  final Location? toLocation;
  final User? fromUser;
  final User? toUser;
  final User movedBy;

  const AssetMovement({
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
}

class AssetMovementTranslation extends Equatable {
  final String langCode;
  final String? notes;

  const AssetMovementTranslation({required this.langCode, this.notes});

  @override
  List<Object?> get props => [langCode, notes];
}
