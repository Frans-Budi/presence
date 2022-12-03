import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEW PASSWORD'),
        centerTitle: true,
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(
          autocorrect: false,
          controller: controller.newPassC,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "New Password",
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            controller.changePass();
          },
          child: Text('CONTINUE'),
        ),
      ]),
    );
  }
}
