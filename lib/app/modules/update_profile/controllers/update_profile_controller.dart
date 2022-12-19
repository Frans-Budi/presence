import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  XFile? imageFile;

  void pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = XFile(image.path);
    } else {
      imageFile = null;
    }
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Map<String, dynamic> data = {
        "name": nameC.text,
      };
      try {
        if (imageFile != null) {
          File file = File(imageFile!.path);
          String ext = imageFile!.name.split('.').last;

          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();
          data.addAll({"profile": urlImage});
        }

        await firestore.collection("pegawai").doc(uid).update(data);
        imageFile = null;
        Get.snackbar('Berhasil', 'Berhasil Update Profile');
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat update profile.');
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection("pegawai").doc(uid).update({
        "profile": FieldValue.delete(),
      });
      Get.back();
      Get.snackbar('Berhasil', 'Berhasil Delete Profile Picture');
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'Tidak dapat Delete profile Picture.');
    } finally {
      update();
    }
  }
}
