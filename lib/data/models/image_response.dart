import 'package:equatable/equatable.dart';

class ImageResponse extends Equatable {
  final String imageBytes;

  const ImageResponse({required this.imageBytes});

  factory ImageResponse.fromJson(json) {
    return ImageResponse(
      imageBytes: json["artifacts"][0]["base64"],
    );
  }

  @override
  List<Object> get props => [imageBytes];
}
