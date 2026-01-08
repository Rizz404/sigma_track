import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/auth/domain/entities/verify_reset_code_response.dart';

class VerifyResetCodeResponseModel extends Equatable {
  final bool valid;

  const VerifyResetCodeResponseModel({required this.valid});

  VerifyResetCodeResponseModel copyWith({bool? valid}) {
    return VerifyResetCodeResponseModel(valid: valid ?? this.valid);
  }

  Map<String, dynamic> toMap() {
    return {'valid': valid};
  }

  factory VerifyResetCodeResponseModel.fromMap(Map<String, dynamic> map) {
    return VerifyResetCodeResponseModel(valid: map['valid'] ?? false);
  }

  String toJson() => json.encode(toMap());

  factory VerifyResetCodeResponseModel.fromJson(String source) =>
      VerifyResetCodeResponseModel.fromMap(json.decode(source));

  VerifyResetCodeResponse toEntity() {
    return VerifyResetCodeResponse(valid: valid);
  }

  @override
  String toString() => 'VerifyResetCodeResponseModel(valid: $valid)';

  @override
  List<Object> get props => [valid];
}
