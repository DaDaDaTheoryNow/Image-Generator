part of 'image_request_bloc.dart';

@immutable
abstract class ImageRequestState extends Equatable {
  const ImageRequestState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageRequestState {}

class ImageLoading extends ImageRequestState {}

class ImageCompleted extends ImageRequestState {
  final String imageBytes;

  const ImageCompleted(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

class ImageError extends ImageRequestState {
  final String error;

  const ImageError(this.error);

  @override
  List<Object> get props => [error];
}
