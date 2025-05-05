import 'package:json_annotation/json_annotation.dart';

part 'detail_story.g.dart';

@JsonSerializable()
class DetailStory {
  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  DetailStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory DetailStory.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DetailStoryFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryToJson(this);
}
