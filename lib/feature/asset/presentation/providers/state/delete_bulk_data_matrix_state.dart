import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset/domain/entities/delete_bulk_data_matrix_response.dart';

enum DeleteBulkDataMatrixStatus { initial, deleting, success, error }

class DeleteBulkDataMatrixState extends Equatable {
  final DeleteBulkDataMatrixStatus status;
  final DeleteBulkDataMatrixResponse? data;
  final String? message;
  final Failure? failure;

  const DeleteBulkDataMatrixState({
    required this.status,
    this.data,
    this.message,
    this.failure,
  });

  factory DeleteBulkDataMatrixState.initial() {
    return const DeleteBulkDataMatrixState(
      status: DeleteBulkDataMatrixStatus.initial,
    );
  }

  factory DeleteBulkDataMatrixState.deleting() {
    return const DeleteBulkDataMatrixState(
      status: DeleteBulkDataMatrixStatus.deleting,
    );
  }

  factory DeleteBulkDataMatrixState.success(
    DeleteBulkDataMatrixResponse data, {
    String? message,
  }) {
    return DeleteBulkDataMatrixState(
      status: DeleteBulkDataMatrixStatus.success,
      data: data,
      message: message,
    );
  }

  factory DeleteBulkDataMatrixState.error(Failure failure) {
    return DeleteBulkDataMatrixState(
      status: DeleteBulkDataMatrixStatus.error,
      failure: failure,
    );
  }

  DeleteBulkDataMatrixState copyWith({
    DeleteBulkDataMatrixStatus? status,
    ValueGetter<DeleteBulkDataMatrixResponse?>? data,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return DeleteBulkDataMatrixState(
      status: status ?? this.status,
      data: data != null ? data() : this.data,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [status, data, message, failure];
}
