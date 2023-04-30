import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:image_generator/data/repositories/image_repository.dart';

import '../../token/token.dart';
import '../models/image_response.dart';

class ImageRepositoryImpl implements ImageRepository {
  final dio = Dio(BaseOptions(
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  final negativeDefault =
      "asian, india, bad anatomy,bad proportions, blurry, cloned face, cropped, deformed, dehydrated, disfigured, duplicate, error, extra arms, extra fingers, extra legs, extra limbs, fused fingers, gross proportions, jpeg artifacts, long neck, low quality, lowres, malformed limbs, missing arms, missing legs, morbid, mutated hands, mutation, mutilated, out of frame, poorly drawn face, poorly drawn hands, signature, text, too many fingers, ugly, username, watermark, worst quality";

  @override
  Future<String> makeRequest(String description, String negative) async {
    // token
    dio.options.headers = {
      'Authorization': 'Token $token',
    };

    try {
      // start generation
      // include link with status and cancel link
      final response = await dio.post(
        "https://api.replicate.com/v1/predictions",
        data: jsonEncode({
          'version':
              "4049a9d8947a75a0b245e3937f194d27e3277bab4a9c1d6f81922919b65175fd",
          'input': {
            'prompt': description,
            'negative_prompt': negative + negativeDefault,
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
        int retries = 20;
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
      if (e is DioError) {
        if (e.response?.statusCode == 404) {
          return throw Exception('Token Error');
        } else if (e.response?.statusCode == 402) {
          return throw Exception('You ran out of requests');
        }
      }

      throw Exception('Failed to fetch chat completions: $e');
    }
  }
}
