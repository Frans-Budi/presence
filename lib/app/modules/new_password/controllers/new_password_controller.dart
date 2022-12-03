import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void changePass() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != "password") {
        String email = await auth.currentUser!.email!;

        try {
          await auth.currentUser!.updatePassword(newPassC.text);
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: newPassC.text);

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar('Terjadi Kesalahan', 'Password terlalu mudah');
          }
        } catch (e) {
          Get.snackbar('Terjadi Kesaahan', 'Tidak dapat mengubah Password');
        }
      } else {
        Get.snackbar(
            'Terjadi Kesalahan', 'Tidak boleh memasukkan password yang sama!');
      }
    } else {
      Get.snackbar('Terjadi Kesaahan', 'New Password harus diisi');
    }
  }
}
