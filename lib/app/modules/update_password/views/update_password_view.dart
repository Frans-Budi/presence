import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPDATE PASSWORD'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: controller.curC,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Current Password",
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: controller.newC,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "New Password",
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: controller.confirmC,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "New Password",
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.updatePass();
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? 'CHANGE PASSWORD'
                  : 'LOADING...'),
            ),
          ),
        ],
      ),
    );
  }
}
