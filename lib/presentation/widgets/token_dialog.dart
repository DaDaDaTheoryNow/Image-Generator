import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_generator/presentation/pages/auth_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../token/token.dart';

void showTokenDialog(BuildContext context, bool first) {
  TextEditingController controller = TextEditingController();

  navigatorPop() {
    Navigator.of(context).pop();
  }

  showDialog(
    barrierDismissible: first ? false : true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.center,
        title: first ? const Text("Token") : const Text("Edit Token"),
        content: FractionallySizedBox(
          heightFactor: 0.5,
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                    labelText: "Token",
                    hintText: "Enter your token",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Instruction",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "• After you click on OK, you will be redirected to the site",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "• On the site, click on the button 'SIGN IN WITH GITHUB' and enter your git account",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "• After you have logged into your account, you will be transferred to to the site with your token",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "• Under the heading 'API TOKEN' is your token, copy it",
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "• Paste it into the token field in my application",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                final route = MaterialPageRoute(
                                    builder: (_) => const AuthPage(
                                        url: "https://replicate.com/account"));

                                Navigator.pushReplacement(context, route);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    "Get token from replicate.com",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ))
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              first ? SystemNavigator.pop() : Navigator.of(context).pop();
            },
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 160, 138, 138)),
            ),
            child: first ? const Text("Cancel - Exit") : const Text("Cancel"),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              token = controller.text;

              await prefs.setString("token", token);

              navigatorPop();
            },
          ),
        ],
      );
    },
  );
}
