import 'package:equatable/equatable.dart';

abstract class Success<T> extends Equatable {
  final T? data;
  final String? message;

  const Success({this.data, this.message});

  @override
  List<Object?> get props => [data, message];
}

class ItemSuccess<T> extends Success<T> {
  const ItemSuccess({required super.data, super.message});

  @override
  List<Object?> get props => [data, message];
}

class OffsetPaginatedSuccess<T> extends Success<List<T>> {
  final Pagination pagination;

  const OffsetPaginatedSuccess({
    required super.data,
    required this.pagination,
    super.message,
  });

  @override
  List<Object?> get props => [...super.props, pagination];
}

class CursorPaginatedSuccess<T> extends Success<List<T>> {
  final Cursor cursor;

  const CursorPaginatedSuccess({
    required super.data,
    required this.cursor,
    super.message,
  });

  @override
  List<Object?> get props => [...super.props, cursor];
}

class ActionSuccess extends Success {
  const ActionSuccess({super.message});

  @override
  List<Object?> get props => [message];
}

class Pagination extends Equatable {
  final int total;
  final int perPage;
  final int currentPage;
  final int totalPages;
  final bool hasPrevPage;
  final bool hasNextPage;

  const Pagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.hasPrevPage,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props => [
    total,
    perPage,
    currentPage,
    totalPages,
    hasPrevPage,
    hasNextPage,
  ];
}

class Cursor extends Equatable {
  final String nextCursor;
  final bool hasNextPage;
  final int perPage;

  const Cursor({
    required this.nextCursor,
    required this.hasNextPage,
    required this.perPage,
  });

  @override
  List<Object?> get props => [nextCursor, hasNextPage, perPage];
}
