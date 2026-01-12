import 'package:equatable/equatable.dart';

class UploadTemplateImagesResponse extends Equatable {
  final List<String> imageUrls;
  final int count;

  const UploadTemplateImagesResponse({
    required this.imageUrls,
    required this.count,
  });

  UploadTemplateImagesResponse copyWith({List<String>? imageUrls, int? count}) {
    return UploadTemplateImagesResponse(
      imageUrls: imageUrls ?? this.imageUrls,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [imageUrls, count];
}
