import 'package:equatable/equatable.dart';

class ImageResponse extends Equatable {
  final String finalUrl;
  final String predictionalUrl;
  final String status;

  const ImageResponse({
    required this.predictionalUrl,
    required this.status,
    required this.finalUrl,
  });

  factory ImageResponse.fromJson(json) {
    return ImageResponse(
      predictionalUrl: json["urls"]["get"],
      status: json["status"],
      finalUrl: json["output"] != null ? json["output"][0] : "null",
    );
  }

  @override
  List<Object> get props => [predictionalUrl, status, finalUrl];
}
