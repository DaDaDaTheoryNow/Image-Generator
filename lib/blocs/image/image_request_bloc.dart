import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../data/repositories/image_repository.dart';

part 'image_request_event.dart';
part 'image_request_state.dart';

class ImageRequestBloc extends Bloc<ImageRequestEvent, ImageRequestState> {
  final ImageRepository _imageRepository;

  ImageRequestBloc(this._imageRepository) : super(ImageInitial()) {
    on<ImageRequest>((event, emit) async {
      emit(ImageLoading());
      try {
        final response = await _imageRepository.makeRequest(
            event.descripion, event.negative);
        emit(ImageCompleted(response));
      } catch (e) {
        emit(ImageError('Failed to generate text: $e'));
      }
    });
  }
}
