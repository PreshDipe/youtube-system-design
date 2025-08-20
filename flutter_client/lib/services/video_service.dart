import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class VideoService {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String backendUrl = "http://35.23.52.233:8000/videos";

  Future<Map<String, String>> _getCookieHeader() async {
    final accessToken = await secureStorage.read(key: 'access_token');

    final headers = {'Content-Type': 'application/json'};

    if (accessToken != null) {
      headers['Cookie'] = 'access_token=$accessToken';
    }

    return headers;
  }

  Future<List<Map<String, dynamic>>> getVideos() async {
    try {
      final res = await http.get(
        Uri.parse("$backendUrl/all"),
        headers: await _getCookieHeader(),
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['detail'] ?? 'Error fetching videos!';
      }

      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    } catch (e) {
      throw e.toString();
    }
  }
}
