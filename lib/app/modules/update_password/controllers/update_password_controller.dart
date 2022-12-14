import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController curC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (curC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          String? emailUser = auth.currentUser!.email;

          await auth.signInWithEmailAndPassword(
              email: emailUser!, password: curC.text);

          // Update Password
          await auth.currentUser!.updatePassword(newC.text);

          Get.back();
          Get.snackbar('Berhasil', 'Berhasil Update Password');
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar('Terjadi Kesalahan', 'Current Password Salah!');
          } else {
            Get.snackbar('Terjadi Kesalahan', '${e.code.toLowerCase()}');
          }
        } catch (e) {
          Get.snackbar('Terjadi Kesalahan', 'Tidak dapat Update Password');
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar('Terjadi Kesalahan', 'Confirm Password tidak cocok');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Semua Input Harus diisi');
    }
  }
}
