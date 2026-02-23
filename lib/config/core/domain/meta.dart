import 'package:equatable/equatable.dart';

class Meta extends Equatable {
  final int totalCount;
  final int pageCount;
  final int currentPage;
  final int perPage;

  const Meta({required this.totalCount, required this.pageCount, required this.currentPage, required this.perPage});

  bool get hasNextPage => currentPage < pageCount;
  bool get hasPreviousPage => currentPage > 1;
  int get nextPage => currentPage + 1;
  int get previousPage => currentPage - 1;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == pageCount;
  int get totalPages => pageCount;
  int get firstItemIndex => (currentPage - 1) * perPage;
  int get lastItemIndex => (currentPage * perPage) - 1;

  factory Meta.empty() => const Meta(totalCount: 0, pageCount: 0, currentPage: 0, perPage: 0);

  @override
  List<Object?> get props => [totalCount, pageCount, currentPage, perPage];
}

class MetaModel extends Meta {
  const MetaModel({required super.totalCount, required super.pageCount, required super.currentPage, required super.perPage});

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      totalCount: json['total'] as int,
      pageCount: json['last_page'] as int,
      currentPage: json['current_page'] as int,
      perPage: json['per_page'] as int,
    );
  }

  factory MetaModel.empty() => const MetaModel(totalCount: 0, pageCount: 0, currentPage: 0, perPage: 0);
}
