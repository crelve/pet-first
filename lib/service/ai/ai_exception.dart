/// Base class for AI-related exceptions
sealed class AiException implements Exception {
  const AiException(this.message, [this.originalError]);

  /// Error message
  final String message;

  /// Original error
  final Object? originalError;

  @override
  String toString() => 'AiException: $message';
}

/// Timeout exception (30 seconds exceeded)
class AiTimeoutException extends AiException {
  /// Create timeout exception
  AiTimeoutException({
    required this.timeout,
    Object? originalError,
  }) : super(
         'AI processing timed out (${timeout.inSeconds} seconds)',
         originalError,
       );

  /// Timeout duration
  final Duration timeout;

  @override
  String toString() => 'AiTimeoutException: $message';
}

/// Network error exception
class AiNetworkException extends AiException {
  /// Create network exception
  const AiNetworkException({
    String message = 'Network connection failed',
    Object? originalError,
  }) : super(message, originalError);

  @override
  String toString() => 'AiNetworkException: $message';
}

/// API configuration error exception
class AiConfigurationException extends AiException {
  /// Create configuration exception
  const AiConfigurationException({
    String message = 'AI service is not configured correctly',
    Object? originalError,
  }) : super(message, originalError);

  @override
  String toString() => 'AiConfigurationException: $message';
}

/// Rate limit exception
class AiRateLimitException extends AiException {
  /// Create rate limit exception
  const AiRateLimitException({
    String message = 'API request limit reached',
    this.retryAfter,
    Object? originalError,
  }) : super(message, originalError);

  /// Retry after duration
  final Duration? retryAfter;

  @override
  String toString() => 'AiRateLimitException: $message';
}

/// Unknown AI error
class AiUnknownException extends AiException {
  /// Create unknown exception
  const AiUnknownException({
    String message = 'An unexpected error occurred',
    Object? originalError,
  }) : super(message, originalError);

  @override
  String toString() => 'AiUnknownException: $message';
}

/// Exception parser
extension AiExceptionParser on Object {
  /// Convert original exception to AiException
  AiException toAiException() {
    final error = this;
    final errorString = error.toString().toLowerCase();

    // Return as-is if already AiException
    if (error is AiException) {
      return error;
    }

    // Network error detection
    if (errorString.contains('socket') ||
        errorString.contains('connection') ||
        errorString.contains('network') ||
        errorString.contains('timeout')) {
      return AiNetworkException(originalError: error);
    }

    // Configuration error detection
    if (errorString.contains('not found') ||
        errorString.contains('not configured') ||
        errorString.contains('api key')) {
      return AiConfigurationException(originalError: error);
    }

    // Rate limit detection
    if (errorString.contains('rate limit') ||
        errorString.contains('quota') ||
        errorString.contains('429')) {
      return AiRateLimitException(originalError: error);
    }

    // Unknown error
    return AiUnknownException(
      message: error.toString(),
      originalError: error,
    );
  }
}
