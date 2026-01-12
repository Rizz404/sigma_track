import 'package:equatable/equatable.dart';

class ImageResponse extends Equatable {
  final String id;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ImageResponse({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, imageUrl, createdAt, updatedAt];
}
