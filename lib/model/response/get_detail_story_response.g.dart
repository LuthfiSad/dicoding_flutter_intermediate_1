// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_detail_story_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDetailStoryRepsonse _$GetDetailStoryRepsonseFromJson(
        Map<String, dynamic> json) =>
    GetDetailStoryRepsonse(
      error: json['error'] as bool,
      message: json['message'] as String,
      story: DetailStory.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetDetailStoryRepsonseToJson(
        GetDetailStoryRepsonse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'story': instance.story,
    };
