import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<UserCredential?> loginMethod({required BuildContext context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message ?? 'An error occurred');
    }
    return userCredential;
  }

  Future<UserCredential?> signupMethod({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message ?? 'An error occurred');
      return null;
    }
    return userCredential;
  }

  Future<void> signoutMethod(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      VxToast.show(context, msg: 'Successfully signed out');
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  void clearLoginFields() {
  emailController.clear();
  passwordController.clear();
  isloading(false);
}

}


