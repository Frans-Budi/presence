import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamRole(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              var role = snap.data!.data()!['role'];

              if (role == 'admin') {
                // Admin
                return IconButton(
                  onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
                  icon: const Icon(Icons.person_add_alt_1, size: 30),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () async {
            if (controller.isLoading.isFalse) {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(Routes.LOGIN);
            }
          },
          child: (controller.isLoading.isFalse)
              ? const Icon(Icons.logout)
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
