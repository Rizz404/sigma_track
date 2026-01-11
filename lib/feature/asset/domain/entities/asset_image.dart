import 'package:equatable/equatable.dart';

class AssetImage extends Equatable {
  final String id;
  final String imageUrl;
  final int displayOrder;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssetImage({
    required this.id,
    required this.imageUrl,
    required this.displayOrder,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [id, imageUrl, displayOrder, isPrimary, createdAt, updatedAt];
  }
}
