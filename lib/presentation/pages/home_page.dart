import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/image/image_request_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController descriptionController = TextEditingController();
    TextEditingController negativeController = TextEditingController();

    return BlocBuilder<ImageRequestBloc, ImageRequestState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Image Generator"),
            leading: IconButton(
                onPressed: () {}, icon: const Icon(Icons.delete_forever)),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<ImageRequestBloc>()
                        .add(ImageRequest(descriptionController.text));
                  },
                  child: const Text("Request"),
                ),
              ),
            ],
          ),
          body: Align(
            alignment: Alignment.center,
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 15, 12, 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // description
                            TextField(
                              controller: descriptionController,
                              decoration: const InputDecoration(
                                  hintText: "write your description here",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (text) {},
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // negative
                            TextField(
                              controller: negativeController,
                              decoration: const InputDecoration(
                                  hintText: "write your negative prompts here",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12)))),
                              onChanged: (text) {},
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<ImageRequestBloc, ImageRequestState>(
                          builder: (context, state) {
                        if (state is ImageLoading) {
                          return const CircularProgressIndicator();
                        }

                        if (state is ImageError) {
                          return Text(state.error);
                        }

                        if (state is ImageCompleted) {
                          return Image(image: NetworkImage(state.imageUrl));
                        }

                        return const Text("wait");
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
