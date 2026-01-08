import 'package:equatable/equatable.dart';

class VerifyResetCodeResponse extends Equatable {
  final bool valid;

  const VerifyResetCodeResponse({required this.valid});

  VerifyResetCodeResponse copyWith({bool? valid}) {
    return VerifyResetCodeResponse(valid: valid ?? this.valid);
  }

  @override
  String toString() => 'VerifyResetCodeResponse(valid: $valid)';

  @override
  List<Object> get props => [valid];
}
