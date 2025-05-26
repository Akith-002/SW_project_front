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
    // Handle different API response formats
    List<T> items;
    if (json.containsKey('records')) {
      // Land Miscellaneous API format
      items = (json['records'] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (json.containsKey('masterFiles')) {
      // Land Acquisition API format
      items = (json['masterFiles'] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      items = <T>[];
    }

    final totalCount = json['totalCount'] as int;
    final pageSize = json['pageSize'] as int;
    final totalPages = json['totalPages'] as int;

    // Handle different page number field names
    final currentPage = json.containsKey('currentPage')
        ? json['currentPage'] as int
        : json['pageNumber'] as int;

    // Calculate hasPrevious and hasNext if not provided
    final hasPrevious = json.containsKey('hasPrevious')
        ? json['hasPrevious'] as bool
        : currentPage > 1;
    final hasNext = json.containsKey('hasNext')
        ? json['hasNext'] as bool
        : currentPage < totalPages;

    return PaginatedResponse(
      items: items,
      totalCount: totalCount,
      currentPage: currentPage,
      pageSize: pageSize,
      totalPages: totalPages,
      hasPrevious: hasPrevious,
      hasNext: hasNext,
    );
  }
}
