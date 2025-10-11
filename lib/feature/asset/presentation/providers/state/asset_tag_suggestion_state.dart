import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset/domain/entities/generate_asset_tag_response.dart';

class AssetTagSuggestionState extends Equatable {
  final GenerateAssetTagResponse? generateAssetTagResponse;
  final bool isLoading;
  final Failure? failure;

  const AssetTagSuggestionState({
    this.generateAssetTagResponse,
    this.isLoading = false,
    this.failure,
  });

  factory AssetTagSuggestionState.initial() =>
      const AssetTagSuggestionState(isLoading: true);

  factory AssetTagSuggestionState.loading() =>
      const AssetTagSuggestionState(isLoading: true);

  factory AssetTagSuggestionState.success(
    GenerateAssetTagResponse generateAssetTagResponse,
  ) => AssetTagSuggestionState(
    generateAssetTagResponse: generateAssetTagResponse,
  );

  factory AssetTagSuggestionState.error(Failure failure) =>
      AssetTagSuggestionState(failure: failure);

  AssetTagSuggestionState copyWith({
    GenerateAssetTagResponse? generateAssetTagResponse,
    bool? isLoading,
    Failure? failure,
  }) {
    return AssetTagSuggestionState(
      generateAssetTagResponse:
          generateAssetTagResponse ?? this.generateAssetTagResponse,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [generateAssetTagResponse, isLoading, failure];
}
