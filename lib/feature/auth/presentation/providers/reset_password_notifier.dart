import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/reset_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:sigma_track/feature/auth/presentation/providers/state/reset_password_state.dart';

class ResetPasswordNotifier extends AutoDisposeNotifier<ResetPasswordState> {
  ForgotPasswordUsecase get _forgotPasswordUsecase =>
      ref.watch(forgotPasswordUsecaseProvider);
  VerifyResetCodeUsecase get _verifyResetCodeUsecase =>
      ref.watch(verifyResetCodeUsecaseProvider);
  ResetPasswordUsecase get _resetPasswordUsecase =>
      ref.watch(resetPasswordUsecaseProvider);

  @override
  ResetPasswordState build() {
    this.logPresentation('Initializing ResetPasswordNotifier');
    return ResetPasswordState.initial();
  }

  Future<void> sendResetCode(String email) async {
    this.logPresentation('Sending reset code to $email');

    state = ResetPasswordState.sendingCode();

    final result = await _forgotPasswordUsecase.call(
      ForgotPasswordUsecaseParams(email: email),
    );

    result.fold(
      (failure) {
        this.logError('Failed to send reset code', failure);
        state = ResetPasswordState.error(failure);
      },
      (success) {
        this.logData('Reset code sent successfully');
        state = ResetPasswordState.codeSent(
          email: email,
          message: success.message,
        );
      },
    );
  }

  Future<void> verifyCode(String email, String code) async {
    this.logPresentation('Verifying reset code for $email');

    state = state.copyWith(
      isLoading: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _verifyResetCodeUsecase.call(
      VerifyResetCodeUsecaseParams(email: email, code: code),
    );

    result.fold(
      (failure) {
        this.logError('Failed to verify code', failure);
        state = state.copyWith(isLoading: false, failure: () => failure);
      },
      (success) {
        this.logData('Code verification result: ${success.data!.valid}');
        if (success.data!.valid) {
          state = ResetPasswordState.codeVerified(
            email: email,
            code: code,
            message: success.message,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            failure: () => const ServerFailure(message: 'Invalid reset code'),
          );
        }
      },
    );
  }

  Future<void> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    this.logPresentation('Resetting password for $email');

    state = state.copyWith(
      isLoading: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _resetPasswordUsecase.call(
      ResetPasswordUsecaseParams(
        email: email,
        code: code,
        newPassword: newPassword,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to reset password', failure);
        state = state.copyWith(isLoading: false, failure: () => failure);
      },
      (success) {
        this.logData('Password reset successfully');
        state = ResetPasswordState.passwordReset(message: success.message);
      },
    );
  }

  void clearState() {
    this.logPresentation('Clearing reset password state');
    state = ResetPasswordState.initial();
  }
}

final resetPasswordNotifierProvider =
    AutoDisposeNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
      ResetPasswordNotifier.new,
    );
