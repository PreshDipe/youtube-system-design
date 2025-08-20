import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UploadVideoService {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String backendUrl = "http://35.23.52.233:8000/upload/video";

  Future<Map<String, String>> _getCookieHeader() async {
    final accessToken = await secureStorage.read(key: 'access_token');

    final headers = {'Content-Type': 'application/json'};

    if (accessToken != null) {
      headers['Cookie'] = 'access_token=$accessToken';
    }

    return headers;
  }

  Future<Map<String, dynamic>> getPresignedUrlForThumbnail(
    String thumbnailId,
  ) async {
    final res = await http.get(
      Uri.parse("$backendUrl/url/thumbnail?thumbnail_id=$thumbnailId"),
      headers: await _getCookieHeader(),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }

    throw jsonDecode(res.body)['detail'] ?? 'Unexpected error occurred';
  }

  Future<Map<String, dynamic>> getPresignedUrlForVideo() async {
    final res = await http.get(
      Uri.parse("$backendUrl/url"),
      headers: await _getCookieHeader(),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }

    throw jsonDecode(res.body)['detail'] ?? 'Unexpected error occurred';
  }

  Future<bool> uploadFileToS3({
    required String presignedUrl,
    required File file,
    required bool isVideo,
  }) async {
    final res = await http.put(
      Uri.parse(presignedUrl),
      headers: {
        'Content-Type': isVideo ? 'video/mp4' : 'image/jpg',
        if (!isVideo) 'x-amz-acl': 'public-read',
      },
      body: file.readAsBytesSync(),
    );

    print(res.body);

    return res.statusCode == 200;
  }

  Future<bool> uploadMetadata({
    required String title,
    required String description,
    required String visibility,
    required String s3Key,
  }) async {
    final res = await http.post(
      Uri.parse("$backendUrl/metadata"),
      headers: await _getCookieHeader(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'visibility': visibility,
        'video_id': s3Key,
        'video_s3_key': s3Key,
      }),
    );

    return res.statusCode == 200;
  }
}
