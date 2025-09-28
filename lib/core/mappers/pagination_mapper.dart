import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/network/models/pagination_info.dart';

extension PaginationMapper on PaginationInfo {
  Pagination toEntity() {
    return Pagination(
      total: total,
      perPage: perPage,
      currentPage: currentPage,
      totalPages: totalPages,
      hasPrevPage: hasPrevPage,
      hasNextPage: hasNextPage,
    );
  }
}

extension PaginationEntityMapper on Pagination {
  PaginationInfo toModel() {
    return PaginationInfo(
      total: total,
      perPage: perPage,
      currentPage: currentPage,
      totalPages: totalPages,
      hasPrevPage: hasPrevPage,
      hasNextPage: hasNextPage,
    );
  }
}
