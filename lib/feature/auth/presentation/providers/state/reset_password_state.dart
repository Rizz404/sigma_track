import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/domain/failure.dart';

enum ResetPasswordStatus {
  initial,
  sendingCode,
  codeSent,
  codeVerified,
  passwordReset,
  error,
}

class ResetPasswordState extends Equatable {
  final ResetPasswordStatus status;
  final String? email;
  final String? code;
  final bool isLoading;
  final String? message;
  final Failure? failure;

  const ResetPasswordState({
    required this.status,
    this.email,
    this.code,
    this.isLoading = false,
    this.message,
    this.failure,
  });

  factory ResetPasswordState.initial() {
    return const ResetPasswordState(status: ResetPasswordStatus.initial);
  }

  factory ResetPasswordState.sendingCode() {
    return const ResetPasswordState(
      status: ResetPasswordStatus.sendingCode,
      isLoading: true,
    );
  }

  factory ResetPasswordState.codeSent({
    required String email,
    String? message,
  }) {
    return ResetPasswordState(
      status: ResetPasswordStatus.codeSent,
      email: email,
      message: message,
    );
  }

  factory ResetPasswordState.codeVerified({
    required String email,
    required String code,
    String? message,
  }) {
    return ResetPasswordState(
      status: ResetPasswordStatus.codeVerified,
      email: email,
      code: code,
      message: message,
    );
  }

  factory ResetPasswordState.passwordReset({String? message}) {
    return ResetPasswordState(
      status: ResetPasswordStatus.passwordReset,
      message: message,
    );
  }

  factory ResetPasswordState.error(Failure failure) {
    return ResetPasswordState(
      status: ResetPasswordStatus.error,
      failure: failure,
    );
  }

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    ValueGetter<String?>? email,
    ValueGetter<String?>? code,
    bool? isLoading,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      email: email != null ? email() : this.email,
      code: code != null ? code() : this.code,
      isLoading: isLoading ?? this.isLoading,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [status, email, code, isLoading, message, failure];
}
