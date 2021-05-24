import 'dart:convert';

import 'package:collection/collection.dart';

import 'version_model.dart';

class ListVersionModel {
  final String name;
  final VersionModel latest;
  final List<VersionModel> versions;

  ListVersionModel({
    required this.name,
    required this.latest,
    required this.versions,
  });

  ListVersionModel copyWith({
    String? name,
    VersionModel? latest,
    List<VersionModel>? versions,
  }) {
    return ListVersionModel(
      name: name ?? this.name,
      latest: latest ?? this.latest,
      versions: versions ?? this.versions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latest': latest.toMap(),
      'versions': versions.map((x) => x.toMap()).toList(),
    };
  }

  factory ListVersionModel.fromMap(Map<String, dynamic> map) {
    return ListVersionModel(
      name: map['name'] as String,
      latest: VersionModel.fromMap(map['latest']),
      versions: List<VersionModel>.from(
        map['versions']?.map(
          (x) => VersionModel.fromMap(x),
        ),
      ),
    );
  }

  List<int> toJson() => json.fuse(utf8).encode(toMap());

  factory ListVersionModel.fromJson(String source) =>
      ListVersionModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ListVersionModel(name: $name, latest: $latest, versions: $versions)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is ListVersionModel &&
        other.name == name &&
        other.latest == latest &&
        listEquals(other.versions, versions);
  }

  @override
  int get hashCode => name.hashCode ^ latest.hashCode ^ versions.hashCode;
}
