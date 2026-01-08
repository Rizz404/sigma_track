import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_bulk_data_matrix_response.dart';

enum BulkDataMatrixStatus { initial, uploading, success, error }

class BulkDataMatrixState extends Equatable {
  final BulkDataMatrixStatus status;
  final UploadBulkDataMatrixResponse? data;
  final String? message;
  final Failure? failure;

  const BulkDataMatrixState({
    required this.status,
    this.data,
    this.message,
    this.failure,
  });

  factory BulkDataMatrixState.initial() {
    return const BulkDataMatrixState(status: BulkDataMatrixStatus.initial);
  }

  factory BulkDataMatrixState.uploading() {
    return const BulkDataMatrixState(status: BulkDataMatrixStatus.uploading);
  }

  factory BulkDataMatrixState.success(
    UploadBulkDataMatrixResponse data, {
    String? message,
  }) {
    return BulkDataMatrixState(
      status: BulkDataMatrixStatus.success,
      data: data,
      message: message,
    );
  }

  factory BulkDataMatrixState.error(Failure failure) {
    return BulkDataMatrixState(
      status: BulkDataMatrixStatus.error,
      failure: failure,
    );
  }

  BulkDataMatrixState copyWith({
    BulkDataMatrixStatus? status,
    ValueGetter<UploadBulkDataMatrixResponse?>? data,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return BulkDataMatrixState(
      status: status ?? this.status,
      data: data != null ? data() : this.data,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [status, data, message, failure];
}
