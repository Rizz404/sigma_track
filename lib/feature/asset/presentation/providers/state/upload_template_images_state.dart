import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_template_images_response.dart';

enum UploadTemplateImagesStatus { initial, uploading, success, error }

class UploadTemplateImagesState extends Equatable {
  final UploadTemplateImagesStatus status;
  final UploadTemplateImagesResponse? data;
  final String? message;
  final Failure? failure;

  const UploadTemplateImagesState({
    required this.status,
    this.data,
    this.message,
    this.failure,
  });

  factory UploadTemplateImagesState.initial() {
    return const UploadTemplateImagesState(
      status: UploadTemplateImagesStatus.initial,
    );
  }

  factory UploadTemplateImagesState.uploading() {
    return const UploadTemplateImagesState(
      status: UploadTemplateImagesStatus.uploading,
    );
  }

  factory UploadTemplateImagesState.success(
    UploadTemplateImagesResponse data, {
    String? message,
  }) {
    return UploadTemplateImagesState(
      status: UploadTemplateImagesStatus.success,
      data: data,
      message: message,
    );
  }

  factory UploadTemplateImagesState.error(Failure failure) {
    return UploadTemplateImagesState(
      status: UploadTemplateImagesStatus.error,
      failure: failure,
    );
  }

  UploadTemplateImagesState copyWith({
    UploadTemplateImagesStatus? status,
    ValueGetter<UploadTemplateImagesResponse?>? data,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return UploadTemplateImagesState(
      status: status ?? this.status,
      data: data != null ? data() : this.data,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [status, data, message, failure];
}
