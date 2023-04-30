import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:image_generator/data/repositories/image_repository.dart';

import '../models/image_response.dart';

class ImageRepositoryImpl implements ImageRepository {
  final dio = Dio(BaseOptions(
    headers: {
      'Authorization': 'Token r8_SDsAHOT3BVT12WRK3IunRVJVum9wFnO0hTqyT',
      'Content-Type': 'application/json',
    },
  ));

  //final apiHost = "https://api.stability.ai";
  //final engineId = "stable-diffusion-v1-5";

  @override
  Future<String?> makeRequest(String description) async {
    try {
      // start generation
      // include link with status and cancel link
      final response = await dio.post(
        "https://api.replicate.com/v1/predictions",
        data: jsonEncode({
          'version':
              "db21e45d3f7023abc2a46ee38a23973f6dce16bb082a930b0c49861f96d1e5bf",
          'input': {
            'prompt': description,
          },
        }),
      );

      // parse link with status from response
      final predictionalUrl =
          ImageResponse.fromJson(response.data).predictionalUrl;

      // api response processing
      try {
        // get predictional response with status
        Response predictionalResponse = await dio.get(
          predictionalUrl,
        );

        // parse status from predictional response
        String status =
            ImageResponse.fromJson(predictionalResponse.data).status;

        // check the response from the api for a picturу
        // every one second
        int retries = 10;
        while (status == "processing" && retries > 0 || status == "starting") {
          await Future.delayed(const Duration(seconds: 1));

          // get predictional response with status again
          predictionalResponse = await dio.get(predictionalUrl);
          // parse status from predictional response again
          status = ImageResponse.fromJson(predictionalResponse.data).status;

          retries--;
        }

        if (retries <= 0) {
          return throw Exception('Time out');
        }

        switch (status) {
          case "succeeded":
            final finalImageRequest = await dio.get(predictionalUrl);
            final finalImage =
                ImageResponse.fromJson(finalImageRequest.data).finalUrl;
            return finalImage;
          case "failed":
            throw Exception(
                'An error has occurred, perhaps the photo contains 18+ or a token error');
          case "canceled":
            throw Exception('Canceled by User');
        }

        return "Try again";
      } catch (e) {
        throw Exception('Failed to fetch chat completions: $e');
      }
    } catch (e) {
      throw Exception('Failed to fetch chat completions: $e');
    }
  }
}
