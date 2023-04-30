part of 'image_request_bloc.dart';

abstract class ImageRequestEvent extends Equatable {}

class ImageRequest extends ImageRequestEvent {
  final String descripion;
  final String negative;

  ImageRequest(this.descripion, this.negative);

  @override
  List<Object> get props => [descripion, negative];
}
