/// Custom exception for API errors
class ApiException implements Exception {
  final String code;
  final int statusCode;
  final String? details;

  ApiException(this.code, this.statusCode, [this.details]);

  @override
  String toString() {
    return 'ApiException: $code (HTTP $statusCode)${details != null ? ' - $details' : ''}';
  }
}
