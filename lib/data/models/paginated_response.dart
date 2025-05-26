class PaginatedResponse<T> {
  final List<T> items;
  final int totalCount;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;

  PaginatedResponse({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final items = (json['masterFiles'] as List)
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
    return PaginatedResponse(
      items: items,
      totalCount: json['totalCount'] as int,
      currentPage: json['currentPage'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
      hasPrevious: json['hasPrevious'] as bool,
      hasNext: json['hasNext'] as bool,
    );
  }
}
