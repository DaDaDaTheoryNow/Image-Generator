part of 'image_request_bloc.dart';

abstract class ImageRequestEvent extends Equatable {}

class ImageRequest extends ImageRequestEvent {
  final String descripion;

  ImageRequest(this.descripion);

  @override
  List<Object> get props => [descripion];
}
