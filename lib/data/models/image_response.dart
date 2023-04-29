import 'package:equatable/equatable.dart';

class ImageResponse extends Equatable {
  final String imageUrl;

  const ImageResponse({required this.imageUrl});

  factory ImageResponse.fromJson(json) {
    return ImageResponse(
      imageUrl: json["output_url"],
    );
  }

  @override
  List<Object> get props => [imageUrl];
}
