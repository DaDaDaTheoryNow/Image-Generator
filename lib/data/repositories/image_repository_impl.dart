import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_generator/data/repositories/image_repository.dart';

import '../models/image_response.dart';

class ImageRepositoryImpl implements ImageRepository {
  final dio = Dio();

  final apiHost = "https://api.stability.ai";
  final engineId = "stable-diffusion-v1-5";

  @override
  Future<String> makeRequest(String description) async {
    try {
      final response = await dio.post(
        "$apiHost/v1/generation/$engineId/text-to-image",
        data: {
          "text_prompts": [
            {"text": description, "weight": 0.3}
          ]
        },
        options: Options(
          headers: {
            "Authorization":
                "Bearer sk-YQvZNVkwLe0pNqmq7KLVjMI9AX00TLGqFcXf3PFEsxjORGI1"
          },
        ),
      );

      debugPrint(response.toString());

      if (response.statusCode == 200) {
        debugPrint(response.toString());
        final imageResponse = ImageResponse.fromJson(response.data);
        return imageResponse.imageBytes;
      } else {
        throw Exception('Failed to fetch chat completions');
      }
    } catch (e) {
      throw Exception('Failed to fetch chat completions: $e');
    }
  }
}
