import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_generator/blocs/image/image_request_bloc.dart';
import 'package:image_generator/data/repositories/image_repository_impl.dart';

import 'presentation/pages/home_page.dart';

void main() {
  final imageRepository = ImageRepositoryImpl();

  runApp(BlocProvider(
    create: (context) => ImageRequestBloc(imageRepository),
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const HomePage()),
  ));
}
