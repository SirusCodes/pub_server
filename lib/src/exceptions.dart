import 'dart:convert';

import 'package:pub_semver/pub_semver.dart';
import 'package:shelf/shelf.dart';

class ApiResponseException implements Exception {
  final int status;
  final String code;
  final String message;

  ApiResponseException({
    required this.status,
    required this.code,
    required this.message,
  });

  Response asApiResponse() => Response(status,
          body: json.fuse(utf8).encode({
            'error': {
              'code': code,
              'message': message,
            },
          }),
          headers: {
            'content-type': 'application/json; charset="utf-8"',
            'x-content-type-options': 'nosniff',
          });
}

/// Base class for all exceptions that are intercepted by HTTP handler wrappers.
abstract class ResponseException extends ApiResponseException {
  ResponseException._(int status, String code, String message)
      : super(status: status, code: code, message: message);

  @override
  String toString() => '$code($status): $message'; // implemented for debugging
}

/// Thrown when resource does not exist.
class NotFoundException extends ResponseException {
  NotFoundException(String message) : super._(404, 'NotFound', message);
  NotFoundException.resource(String resource)
      : super._(404, 'NotFound', 'Could not find `$resource`.');
}

/// Thrown when request is not acceptable.
class NotAcceptableException extends ResponseException {
  NotAcceptableException(String message)
      : super._(406, 'NotAcceptable', message);
}

/// Thrown when request input is invalid, bad payload, wrong querystring, etc.
class InvalidInputException extends ResponseException {
  InvalidInputException._(String message)
      : super._(
          400,
          'InvalidInput', // also duplicated in api_builder.dart
          message,
        );

  /// Thrown when the parsing and/or validating of the continuation token failed.
  InvalidInputException.continuationParseError()
      : this._('Parsing the continuation token failed.');

  /// Thrown when the canonicalization of the [version] failed.
  InvalidInputException.canonicalizeVersionError(String version)
      : this._('Unable to canonicalize the version: $version');

  /// Check [condition] and throw [InvalidInputException] with [message] if
  /// [condition] is `false`.
  static void check(bool condition, String message) {
    if (!condition) {
      throw InvalidInputException._(message);
    }
  }

  /// A variant of [check] with lazy message construction.
  static void _check(bool condition, String Function() message) {
    if (!condition) {
      throw InvalidInputException._(message());
    }
  }

  /// Throw [InvalidInputException] if [value] is not `null`.
  static void checkNull(dynamic value, String name) {
    _check(value == null, () => '"$name" must be `null`');
  }

  /// Throw [InvalidInputException] if [value] is `null`.
  static void checkNotNull(dynamic value, String name) {
    _check(value != null, () => '"$name" cannot be `null`');
  }

  /// Throw [InvalidInputException] if [value] doesn't match [regExp].
  static void checkMatchPattern(String value, String name, RegExp regExp) {
    _check(regExp.hasMatch(value), () => '"$name" must match $regExp');
  }

  /// Throw [InvalidInputException] if [value] is not one of [values].
  static void checkAnyOf<T>(T value, String name, Iterable<T> values) {
    _check(values.contains(value),
        () => '"$name" must be any of ${values.join(', ')}');
  }

  /// Throw [InvalidInputException] if [value] is less than [minimum] or greater
  /// than [maximum].
  static void checkRange<T extends num>(
    T? value,
    String name, {
    T? minimum,
    T? maximum,
  }) {
    _check(value != null, () => '"$name" cannot be `null`');
    _check((minimum == null || (value != null && value >= minimum)),
        () => '"$name" must be greater than $minimum');
    _check((maximum == null || (value != null && value <= maximum)),
        () => '"$name" must be less than $maximum');
  }

  /// Throw [InvalidInputException] if [value] is shorter than [minimum] or
  /// longer than [maximum].
  ///
  /// This also throws if [value] is `null`.
  static void checkStringLength(
    String? value,
    String name, {
    int? minimum,
    int? maximum,
  }) {
    _check(value != null, () => '"$name" cannot be `null`');
    _check((minimum == null || (value != null && value.length >= minimum)),
        () => '"$name" must be longer than $minimum charaters');
    _check((maximum == null || (value != null && value.length <= maximum)),
        () => '"$name" must be less than $maximum charaters');
  }

  /// Throw [InvalidInputException] if [value] is shorter than [minimum] or
  /// longer than [maximum].
  static void checkLength<T>(
    Iterable<T>? value,
    String name, {
    int? minimum,
    int? maximum,
  }) {
    _check(value != null, () => '"$name" cannot be `null`');
    final length = value!.length;
    _check((minimum == null || length >= minimum),
        () => '"$name" must be longer than $minimum');
    _check((maximum == null || length <= maximum),
        () => '"$name" must be less than $maximum');
  }

  static final _ulidPattern = RegExp(r'^[a-zA-Z0-9]*$');

  static void checkUlid(String value, String name) {
    _check(_ulidPattern.hasMatch(value), () => '"$name" is not a valid ulid.');
  }

  static void checkSemanticVersion(String version) {
    checkNotNull(version, 'version');
    try {
      Version.parse(version);
    } on FormatException catch (_) {
      throw InvalidInputException._(
          'Version string "$version" is not a valid semantic version.');
    }
  }
}
