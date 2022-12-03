import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    try {
      String emailAdmin = auth.currentUser!.email!;

      UserCredential credentialAdmin = await auth.signInWithEmailAndPassword(
        email: emailAdmin,
        password: passAdminC.text,
      );

      UserCredential credentialPegawai =
          await auth.createUserWithEmailAndPassword(
        email: emailC.text,
        password: 'password',
      );

      if (credentialPegawai.user != null) {
        String uid = credentialPegawai.user!.uid;

        firestore.collection("pegawai").doc(uid).set({
          "nip": nipC.text,
          "name": nameC.text,
          "email": emailC.text,
          "uid": uid,
          "role": "pegawai",
          "createAt": DateTime.now().toIso8601String(),
        });

        await credentialPegawai.user!.sendEmailVerification();

        await auth.signOut();

        UserCredential credentialAdmin = await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );

        Get.back();
        Get.back();

        Get.snackbar('Selamat', 'Data Berhasil Ditambahkan');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Terjadi Kesalahan', 'Password Terlalu Singkat');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Terjadi Kesalahan', 'Pegawai sudah Terdaftar');
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
            'Terjadi Kesalahan', 'Admin tidak dapat login, Password Salah!');
      } else {
        Get.snackbar('Terjadi Kesalahan', '${e.code}');
      }
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'Tidak Dapat Menambahkan Pegawai');
    }
  }

  Future<void> addPegawai() async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      Get.defaultDialog(
          title: "Validasi Admin",
          content: Column(
            children: [
              const Text('Masukkan password untuk validasi admin !'),
              TextField(
                autocorrect: false,
                obscureText: true,
                controller: passAdminC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  isLoading.value = true;
                  await prosesAddPegawai();
                  isLoading.value = false;
                },
                child: Text(isLoading.isFalse ? 'Add Pegawai' : 'Loading...'),
              ),
            ),
          ]);
    } else {
      Get.snackbar(
          'Terjadi Kesalahan', 'Nip, Nama, dan Email Tidak boleh Kosong');
    }
  }
}
