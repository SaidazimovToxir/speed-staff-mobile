import 'vacancy.dart';

class PaginatedVacancies {
  final List<Vacancy> items;
  final int page;
  final int limit;
  final int total;
  final int pages;
  final bool hasNext;
  final bool hasPrev;

  const PaginatedVacancies({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
    required this.hasNext,
    required this.hasPrev,
  });
}
