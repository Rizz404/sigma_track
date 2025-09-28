import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/network/models/cursor_info.dart';

extension CursorMapper on CursorInfo {
  Cursor toEntity() {
    return Cursor(
      nextCursor: nextCursor,
      hasNextPage: hasNextPage,
      perPage: perPage,
    );
  }
}

extension CursorEntityMapper on Cursor {
  CursorInfo toModel() {
    return CursorInfo(
      nextCursor: nextCursor,
      hasNextPage: hasNextPage,
      perPage: perPage,
    );
  }
}
