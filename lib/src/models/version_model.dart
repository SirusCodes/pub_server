import 'dart:convert';

import 'package:collection/collection.dart';

class VersionModel {
  final String version;
  final String archive_url;
  final Map<dynamic, String> pubspec;

  VersionModel({
    required this.version,
    required this.archive_url,
    required this.pubspec,
  });

  VersionModel copyWith({
    String? version,
    String? archive_url,
    Map<dynamic, String>? pubspec,
  }) {
    return VersionModel(
      version: version ?? this.version,
      archive_url: archive_url ?? this.archive_url,
      pubspec: pubspec ?? this.pubspec,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'archive_url': archive_url,
      'pubspec': pubspec,
    };
  }

  factory VersionModel.fromMap(Map<String, dynamic> map) {
    return VersionModel(
      version: map['version'] as String,
      archive_url: map['archive_url'] as String,
      pubspec: Map<dynamic, String>.from(map['pubspec']),
    );
  }

  String toJson() => json.encode(toMap());

  factory VersionModel.fromJson(String source) =>
      VersionModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'VersionModel(version: $version, archive_url: $archive_url, pubspec: $pubspec)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return other is VersionModel &&
        other.version == version &&
        other.archive_url == archive_url &&
        mapEquals(other.pubspec, pubspec);
  }

  @override
  int get hashCode =>
      version.hashCode ^ archive_url.hashCode ^ pubspec.hashCode;
}
