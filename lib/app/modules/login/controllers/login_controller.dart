import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        if (credential.user != null) {
          isLoading.value = false;
          if (credential.user!.emailVerified == true) {
            if (passC.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: "Belum Verifikasi",
              middleText:
                  "Akun ini belum diverifikasi, lakukan verfikasi akun mu!",
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
                      try {
                        await credential.user!.sendEmailVerification();
                        isLoading.value = false;
                        Get.back();
                        Get.snackbar('Berhasil dikirim',
                            'Kami telah mengirim email verfikasi');
                      } catch (e) {
                        Get.snackbar('Terjadi Kesalahan',
                            'Tidak dapat mengirim email verifikasi, hubungi admin atau customer service');
                      }
                    },
                    child: Text(isLoading.isFalse ? 'Kirim' : 'Loading...'),
                  ),
                ),
              ],
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', 'Akun Tidak Terdaftar');
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
              'Terjadi Kesalahan', 'Password yang Anda masukkan salah');
        }
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak Dapat Login');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Email dan Password Harus diisi!');
    }
  }
}
