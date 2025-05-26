class PaginatedResponse<T> {
  final List<T> items;
  final String? nextPageToken;

  PaginatedResponse({required this.items, this.nextPageToken});
}
