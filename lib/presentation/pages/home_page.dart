import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/image/image_request_bloc.dart';
import '../../token/token.dart';
import '../widgets/token_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    tokenInit();
  }

  tokenInit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final tokenPrefs = prefs.getString("token");

    if (tokenPrefs == null) {
      Future.microtask(() => showTokenDialog(context, true));
    } else {
      token = tokenPrefs;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController descriptionController = TextEditingController();
    TextEditingController negativeController = TextEditingController();

    return BlocBuilder<ImageRequestBloc, ImageRequestState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Image Generator",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () => showTokenDialog(context, false),
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 160, 138, 138)),
                  ),
                  child: const Text("Chagne Token"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () => context.read<ImageRequestBloc>().add(
                      ImageRequest(
                          descriptionController.text, negativeController.text)),
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
                                  hintText:
                                      "write your negative prompts here (optional)",
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
                          Future.microtask(() => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    content: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(state.imageUrl),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ));
                        }

                        return const Text(
                          "Development by Vladsilav Smirnov - tg @DaDaDa17",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
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
