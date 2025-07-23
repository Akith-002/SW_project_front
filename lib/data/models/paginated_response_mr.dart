class PaginatedResponse<T> {
  final List<T> items;
  final String? nextPageToken;
  final int totalCount;

  PaginatedResponse({
    required this.items, 
    this.nextPageToken,
    this.totalCount = 0,
  });
}
