import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_generator/data/repositories/image_repository.dart';

import '../models/image_response.dart';

class ImageRepositoryImpl implements ImageRepository {
  final dio = Dio();

  @override
  Future<String> makeRequest(String description) async {
    try {
      var response = await dio.post(
        'https://api.deepai.org/api/fantasy-portrait-generator',
        data: FormData.fromMap(
          {
            'text': description,
            "grid_size": 1,
          },
        ),
        options: Options(
          headers: {
            'api-key': 'quickstart-QUdJIGlzIGNvbWluZy4uLi4K',
          },
        ),
      );

      debugPrint(response.toString());

      if (response.statusCode == 200) {
        debugPrint(response.toString());
        final imageResponse = ImageResponse.fromJson(response.data);
        return imageResponse.imageUrl;
      } else {
        throw Exception('Failed to fetch chat completions');
      }
    } catch (e) {
      throw Exception('Failed to fetch chat completions: $e');
    }
  }
}
